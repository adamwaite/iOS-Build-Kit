require 'fileutils'

def create_spec_temp_dir
	FileUtils.mkdir_p "spec/temp"
end

def destroy_spec_temp_dir
	FileUtils.rm_rf "spec/temp"
end