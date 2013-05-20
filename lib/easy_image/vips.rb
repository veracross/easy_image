require 'vips'

# This class is almost a direct copy of vips.rb from carrierwave-vips
class EasyImage
  class Vips

    def initialize(path)
      @path = path
      @image = ::VIPS::Image.new path
    end

    ##
    # See EasyImage::resize_to_fit
    def resize_to_fit(width, height)
      resize_image width, height
    end

    ##
    # See EasyImage::resize_to_fill
    def resize_to_fill(width, height)
      resize_image width, height, :max

      if @image.x_size > width
        top = 0
        left = (@image.x_size - width) / 2
      elsif @image.y_size > height
        left = 0
        top = (@image.y_size - height) / 2
      else
        left = 0
        top = 0
      end

      @image = @image.extract_area left, top, width, height
    end

    ##
    # See EasyImage::resize_to_limit
    def resize_to_limit(width, height)
      if width < @image.x_size || height < @image.y_size
        resize_image width, height
      end
    end

    ##
    # See EasyImage::save
    # The format param accepts 'jpg' or 'png'
    def save(path, format=nil, quality=nil)
      ext = File.extname(path)[1..-1]
      if not format
        format = (ext and ext.downcase == 'png') ? 'png' : 'jpg'
      end

      output_path = path.sub(/\.\w+$/, '') + ".#{format}"

      if format == 'jpg'
        writer = ::VIPS::JPEGWriter.new @image, :quality => (quality || 80)
      else
        writer = ::VIPS::PNGWriter.new @image
      end

      writer.write output_path

      # Reset the image so we can use it again
      @image = ::VIPS::Image.new @path

      output_path
    end

    private

    def resize_image(width, height, min_or_max=:min)
      ratio = get_ratio width, height, min_or_max
      return @image if ratio == 1

      if jpeg? # find the shrink ratio for loading
        shrink_factor = [8, 4, 2, 1].find {|sf| 1.0 / ratio >= sf }
        shrink_factor = 1 if shrink_factor == nil
        @image = ::VIPS::Image.jpeg @path,
            :shrink_factor => shrink_factor, :sequential => true
        ratio = get_ratio width, height, min_or_max
      elsif png?
        @image = ::VIPS::Image.png @path, :sequential => true
      end

      if ratio > 1
        @image = @image.affinei_resize :nearest, ratio
      else
        if ratio <= 0.5
          factor = (1.0 / ratio).floor
          @image = @image.shrink(factor)
          @image = @image.tile_cache(@image.x_size, 1, 30)
          ratio = get_ratio width, height, min_or_max
        end
        @image = @image.affinei_resize :bicubic, ratio
        #@image = @image.conv begin
        #  conv_mask = [
        #    [ -1, -1, -1 ],
        #    [ -1, 24, -1 ],
        #    [ -1, -1, -1 ]
        #  ]
        #  ::VIPS::Mask.new conv_mask, 16
        #end
      end
    end

    def get_ratio(width, height, min_or_max=:min)
      width_ratio = width.to_f / @image.x_size
      height_ratio = height.to_f / @image.y_size
      [width_ratio, height_ratio].send(min_or_max)
    end

    def jpeg?
      @path =~ /.*jpg$/i or @path =~ /.*jpeg$/i
    end

    def png?
      @path =~ /.*png$/i
    end
  end
end