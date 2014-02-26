require 'rake'

$:.push File.expand_path("../lib", __FILE__)

Dir["lib/ios_build_kit/**/*.rb"].reject { |file| file.include? "lib/ios_build_kit/version.rb" }.each { |f| load(f) }

require_relative 'support/config_mocker.rb'
require_relative 'support/temp_dir.rb'

RSpec.configure do |config|
  
  config.color_enabled = true
  config.tty = true
	config.formatter = :documentation
	config.fail_fast = true

	config.before(:each) do
    create_spec_temp_dir
    clone_and_modify_icons
  end

	config.after(:each) do 
    destroy_spec_temp_dir
  end

end