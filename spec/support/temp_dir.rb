require 'fileutils'

def create_spec_temp_dir
	FileUtils.mkdir_p temp_dir_path
end

def destroy_spec_temp_dir
	#FileUtils.rm_rf temp_dir_path
end

def temp_dir_path
  "spec/temp"
end

def clone_and_modify_icons
  icons_dir = vc[:configuration][:icon_dir]
  FileUtils.mkdir_p temp_icon_dir_path
  FileUtils.cp_r(Dir["#{icons_dir}/*.png"].reject { |f| f.include? "Decorated" }, temp_icon_dir_path)
end

def temp_icon_dir_path
  "#{temp_dir_path}/icons/"
end