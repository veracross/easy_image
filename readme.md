# EasyImage

A library that wraps up ruby-vips and mini_magick to provide efficient processing of images with a very simple API.

## Installation

Install the latest stable release:

```
[sudo] gem install easy_image
```

In Rails, add it to your Gemfile:

```ruby
gem 'easy_image'
```

## Usage

EasyImage can read and write JPG, PNG and GIF files.

```ruby
image = EasyImage.new('/path/to/file')
```

Images can be resized and cropped with three different methods:

 - `resize_to_limit(width, height)`: resize an image down to fit the width and height, maintaining the image ratio
 - `resize_to_fit(width, height)`: resize an image up or down to fir the width and height, maintaining the image ratio
 - `resize_to_fill(width, height)`: crop and resize to fit the width and height

`resize_to_limit` and `resize_to_fill` will only be performed if the image is currently larger than the requested width and height.

```
# Create a large version
image.resize_to_limit 1000, 1000

# Crop to create a thumbnail
other_image.resize_to_fit 100, 100
```

When saving a file, you must provide a destination. EasyImage will return the actual output path, which may differ from the requested destination due to setting the proper file extension.

The second optional parameter is the JPG quality setting to use if a JPG is being created.

```
output_path = image.save('/desired/output/path.jpg', 80)
```

## License

Copyright (c) 2012-2013 Will Bond (Breuer & Co LLC) <wbond@breuer.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


Copyright (c) 2008-2013 Jonas Nicklas

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


Contains code from the carrierwave-vips gem, which is not explicitly licensed, but was written by:

Jeremy Nicoll <eltiare@github.com>
John Cupitt (@jcupitt)
Stanislaw Pankevich (@stanislaw)
Mario Visic (@mariovisic)