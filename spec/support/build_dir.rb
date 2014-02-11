require 'fileutils'

def create_spec_build_dir
	FileUtils.mkdir_p "specs/builds"
end

def destroy_spec_build_dir
	FileUtils.rm_rf "specs/builds"
end