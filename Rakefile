# -*- ruby -*-

require 'rubygems'
require 'hoe'
require './lib/beenverified.rb'
require 'fileutils'

Hoe.new('beenverified', BeenVerified::VERSION) do |p|
   p.rubyforge_name = 'beenverified' # if different than lowercase project name
   p.developer('Jason Amster', 'jayamster@gmail.com')
end

# vim: syntax=Ruby


desc "Install GEM Locally"
task :install_locally => [:install_gem] do
  FileUtils.rm_rf File.dirname(__FILE__) + '/pkg'
end

desc "Update Site"
task :update_site do
  `scp #{File.dirname(__FILE__)}/site/index.html jamster@rubyforge.org:/var/www/gforge-projects/beenverified`
end
#Rake::Task[“my-sub-task”].invoke If you want to pass command-line params, set ENV[“MY_PARAM_NAME”]