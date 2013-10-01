class XcodeProjectConfig
	
  require 'find'
  
	attr_accessor :project_name, :dev_mode
	
	def initialize(attributes = {})
    check_ruby_version
    @dev_mode = false
    puts "\nXCode iOS Project Configuration"
    puts "-------------------------------\n"
    puts "App name?"
    @project_name = gets
    @project_name.chomp!
    puts "cool name, #{@project_name}"
    rename_files_and_folders
    puts "Use ContiniOS Integration tooling? (y for yes)"
    answer = gets
    if (answer == "y")
      puts "Install dependencies (xctool, imagemagick, ghostscript, rmagick, rake, paint, nomad-cli)? (y for yes)"
      answer = gets
      install_deps if ((answer == "y") or (answer == "yes"))
    else
      remove_ci_tools
    end
    remove_docs_and_config
    puts "All done, open up #{@project_name}.xcworkspace and make an app."
	end

  def check_ruby_version
    ruby_version = RUBY_VERSION
    ruby_split_version = ruby_version.split(".").map { |s| s.to_i }
    ruby_major = ruby_split_version[0].nil? ? 0 : ruby_split_version[0]
    ruby_minor = ruby_split_version[1].nil? ? 0 : ruby_split_version[1]
    ruby_revision = ruby_split_version[2].nil? ? 0 : ruby_split_version[2]
    ruby_major_minor = "#{ruby_major}.#{ruby_minor}".to_f
    if ruby_major_minor < 1.9
      puts "XcodeProject requires Ruby 1.9+, you are running version #{ruby_version}. Update your Ruby and try again, consider using rvm for managing Rubies."
      exit
    end
  end

	def rename_files_and_folders
    puts "renaming files, folders and updating project settings..."  
    overwrite = "APPNAME"

    # this method implementation isn't great, find a new way to do it... 

    # rename files and folders
    5.times do
      Dir["**/*"].each do |f|
        file_name = File.absolute_path f
        unless File.directory? file_name
          content = File.read(file_name).force_encoding('UTF-8').encode('ascii', :invalid => :replace, :replace => '?', :undef => :replace).encode('UTF-8')
          content.gsub!(overwrite, @project_name)
          File.open(f, 'w') { |file| file.write content }
        end
      end
    end

    # rename files and folders
    5.times do
      Dir["**/*"].each do |f|
        file_name = File.absolute_path f
        should_rename = file_name.include? overwrite
        new_file_name = file_name.gsub(overwrite, @project_name)
        File.rename(f, new_file_name) if (should_rename and File.exists? f)
      end
    end

	end
  
	def install_deps
    puts "installing dependencies, you may be asked for your password..."
    system "brew install xctool"
    system "brew install imagemagick"
    system "brew install ghostscript"
    system "sudo gem install rmagick"
    system "sudo gem install rake"
    system "sudo gem install paint"
    system "sudo gem install nomad-cli"
	end

  def remove_ci_tools
    system "rm -rf ContiniOSIntegration/" if File.exists? Dir.pwd + "/ContiniOSIntegration/"
  end
  
  def remove_docs_and_config
    puts "trashing unecessary files..."
    puts "well, would have done if dev mode wasn't on" if @dev_mode
    if !@dev_mode
      system "rm configure.rb" if File.exists? Dir.pwd + "/configure.rb"
      system "rm -rf img/" if File.exists? Dir.pwd + "/img/"
      system "rm -rf .git/" if File.exists? Dir.pwd + "/.git/"
      Dir["**/*"].each do |f|
        file = File.absolute_path f
        should_delete = file.include? "README"
        File.delete file if should_delete
      end
    end
  end
  	
end

configure = XcodeProjectConfig.new()
