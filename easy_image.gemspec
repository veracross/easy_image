Gem::Specification.new do |s|
  s.name        = 'easy_image'
  s.version     = '0.5.2'
  s.date        = '2013-05-20'

  s.summary     = "Exceedingly simple image operations powered by vips and imagemagick"
  s.description = "A wrapper around ruby-vips and mini_magick to provide super-efficient image manipulation with a very simple API"

  s.authors     = ['Will Bond', 'Jonas Nicklas', 'Jeremy Nicoll']
  s.email       = ['wbond@breuer.com', 'jonas.nicklas@gmail.com', 'eltiare@github.com']
  s.homepage    = 'http://github.com/veracross/easy_image'
  s.license     = 'MIT'

  s.files       = ['lib/easy_image.rb', 'lib/easy_image/vips.rb', 'lib/easy_image/mini_magick.rb']

  s.add_runtime_dependency 'mini_magick', '>= 3.4', '< 4.0'
  s.add_runtime_dependency 'dimensions', '>= 1.2', '< 2.0'
  s.add_runtime_dependency 'mime_inspector', '>= 0.5', '< 1.0'
end