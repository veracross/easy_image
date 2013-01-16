require 'mime_inspector'
require 'dimensions'
require 'fileutils'

##
# Provides a simple API to performing common image operations using
# the most appropriate of libvips or imagemagick
class EasyImage

  ##
  # @param [String] path  The filesystem path to the file to manipulate
  # @param [String] mime_type  The mime_type of the file, if previously detected. This should normally be omitted.
  # @return [EasyImage]
  def initialize(path, mime_type=nil)
    if not mime_type
      mime_type = MimeInspector.determine path
    end

    @mime_type = mime_type
    @operations = []
    @path = path
    @width, @height = Dimensions.dimensions path
  end

  ##
  # Resize the image to fit within the specified dimensions while retaining
  # the original aspect ratio. Will only resize the image if it is larger than the
  # specified dimensions. The resulting image may be shorter or narrower than specified
  # in the smaller dimension but will not be larger than the specified values.
  #
  # @param [Integer] width  the width to scale the image to
  # @param [Integer] height  the height to scale the image to
  def resize_to_limit(width, height)
    if @width > width or @height > height
      @operations << [:resize_to_limit, width, height]
    end
  end

  ##
  # Resize the image to fit within the specified dimensions while retaining
  # the original aspect ratio. The image may be shorter or narrower than
  # specified in the smaller dimension but will not be larger than the specified values.
  #
  # @param [Integer] width  the width to scale the image to
  # @param [Integer] height  the height to scale the image to
  def resize_to_fit(width, height)
    @operations << [:resize_to_fit, width, height]
  end

  ##
  # Resize the image to fit within the specified dimensions while retaining
  # the aspect ratio of the original image. If necessary, crop the image in the
  # larger dimension.
  #
  # @param [Integer] width  the width to fill the image to
  # @param [Integer] height  the height to fill the image to
  def resize_to_fill(width, height)
    if @width > width or @height > height
      @operations << [:resize_to_fill, width, height]
    end
  end

  ##
  # Saves the queued changes to the path specified, returning the path in case the extension was changed
  # 
  # @param [String] path  the desired filesystem output path
  # @param [Integer] quality  if the output is a jpg, use this for the quality setting
  # @return [String] the filesystem path to the saved version - this may be different than the path parameter because for format conversion
  def save(path, quality=nil)
    # Fix the output path to have the correct extension
    case @mime_type
      when 'image/png' then ext = 'png'
      when 'image/gif' then ext = 'gif'
      else ext = 'jpg'
    end
    path = path.sub(/\.\w+$/, '') + ".#{ext}"

    # Optimize for situations where the file does not need to be processed at all
    if @operations.length == 0
      if path != @path
        FileUtils.copy @path, path
      end
      return path
    end

    if ext == 'gif'
      processor = EasyImage::MiniMagick.new @path
    else
      processor = EasyImage::Vips.new @path
    end

    begin
      @operations.each do |args|
        processor.send *args
      end

      return processor.save path, ext, quality

    # Vips had an issue with at least one PNG, so if there is an error
    # processing a file, fall back to ImageMagick
    rescue VIPS::Error
      processor = EasyImage::MiniMagick.new @path
      retry
    end
  end
end