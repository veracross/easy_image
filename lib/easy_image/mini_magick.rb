require 'mini_magick'

# This class is almost a direct copy of mini_magick.rb from carrierwave but it
# is only intended for gif files, all other files should run through Vips
class EasyImage
  class MiniMagick

    def initialize(path)
      @path = path
      @image = ::MiniMagick::Image.open(path)
      @dirty = false
    end

    ##
    # See EasyImage::resize_to_limit
    def resize_to_limit(width, height)
      reset
      @image.resize "#{width}x#{height}>"
    end

    ##
    # See EasyImage::resize_to_fit
    def resize_to_fit(width, height)
      reset
      @image.resize "#{width}x#{height}"
    end

    ##
    # See EasyImage::resize_to_fill
    def resize_to_fill(width, height)
      reset
      cols, rows = @image[:dimensions]
      @image.combine_options do |cmd|
        if width != cols || height != rows
          scale_x = width/cols.to_f
          scale_y = height/rows.to_f
          if scale_x >= scale_y
            cols = (scale_x * (cols + 0.5)).round
            rows = (scale_x * (rows + 0.5)).round
            cmd.resize "#{cols}"
          else
            cols = (scale_y * (cols + 0.5)).round
            rows = (scale_y * (rows + 0.5)).round
            cmd.resize "x#{rows}"
          end
        end
        cmd.gravity 'Center'
        cmd.background "rgba(255,255,255,0.0)"
        cmd.extent "#{width}x#{height}" if cols != width || rows != height
      end
    end

    ##
    # See EasyImage::save
    def save(path, format='gif', quality=nil)
      ext = File.extname(path)[1..-1]
      if not format
        case ext
          when 'png' then format = 'png'
          when 'gif' then format = 'gif'
          else format = 'jpg'
        end
      end

      output_path = path.sub(/\.\w+$/, '') + ".#{format}"

      @image.write output_path

      @dirty = true

      output_path
    end

    private

    def reset
      if @dirty
        @image = ::MiniMagick::Image.open @path
        @dirty = false
      end
    end
  end
end