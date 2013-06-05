class XcodeProjectConfig
	
  require 'find'
  
	attr_accessor :project_name, :dev_mode
	
	def initialize(attributes = {})
    @dev_mode = false
    puts "\nXCode iOS Project Configuration"
    puts "-------------------------------\n"
    puts "App name?"
    @project_name = gets
    @project_name.chomp!
    puts "cool name, #{@project_name}"
    rename_files_and_folders
    install_deps
    remove_docs_and_config
    puts "All done, open up #{@project_name}.xcworkspace and make an app."
	end
  
	def rename_files_and_folders
    puts "renaming files, folders and updating project settings..."
    system "unset LANG"
    system "find . -type f | xargs sed -i '' 's/HELLOWORLD/#{@project_name}/g'"
    5.times do
      Dir["**/*"].each do |f|
        file_name = File.absolute_path f
        should_rename = file_name.include? "HELLOWORLD"
        new_file_name = file_name.gsub("HELLOWORLD", "#{@project_name}")
        File.rename(f, new_file_name) if (should_rename and File.exists? f)
      end
    end
	end
  
	def install_deps
    puts "installing dependencies, you may be asked for your password..."
    system "brew install xctool"
    system "brew install imagemagick"
    system "sudo gem install rmagick"
    system "sudo gem install rake"
	end
  
  def remove_docs_and_config
    puts "trashing unecessary files..."
    puts "well, would have done if dev mode wasn't on" if @dev_mode
    system "rm configure.rb" if (File.exists? Dir.pwd + "/configure.rb" and !@dev_mode)
    system "rm README.md" if (File.exists? Dir.pwd + "/README.md" and !@dev_mode)
    system "rm -rf img/" if (File.exists? Dir.pwd + "/img/" and !@dev_mode)
  end
  	
end

configure = XcodeProjectConfig.new()
