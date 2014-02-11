require 'rake'
require 'pry'
require_relative '../build_kit'
require_relative 'support/config_mocker.rb'
require_relative 'support/build_dir.rb'
require_relative 'support/file_clear.rb'
Dir[File.dirname(__FILE__) + '../utils/*.rb'].each {|file| require file }

RSpec.configure do |config|
  config.color_enabled = true
  config.tty = true
	config.formatter = :documentation
	config.fail_fast = true

	config.before(:each) { create_spec_build_dir }
	config.after(:each) { destroy_spec_build_dir }

end