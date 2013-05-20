# based on instructions here:
# http://en.wikibooks.org/wiki/Ruby_Programming/RubyGems#How_to_install_different_versions_of_gems_depending_on_which_version_of_ruby_the_installee_is_using
require 'rubygems'
require 'rubygems/command.rb'
require 'rubygems/dependency_installer.rb'

begin
  Gem::Command.build_args = ARGV
  rescue NoMethodError
end

installer = Gem::DependencyInstaller.new

begin
  if RUBY_PLATFORM =~ /darwin/
    puts "Not installing ruby-vips due to X11 dependencies"
  else
    installer.install "ruby-vips"
  end
rescue Exception => e
  puts e.message
  puts e.backtrace.join("\n")
  exit(1)
end

f = File.open(File.join(File.dirname(__FILE__), "Rakefile"), "w")   # create dummy rakefile to indicate success
f.write("task :default\n")
f.close

exit