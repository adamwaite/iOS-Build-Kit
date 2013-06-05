module ContiniOSIntegration
  
  # task runner instance
  class CITaskRunner
    
    # ensure single task running instance
    require 'singleton'
    include Singleton
    
    # require tasks and utilities
    require 'find'
    require 'pp'
    Dir["./tasks/*.rb"].each {|file| require file }
    
    # accesssors
    attr_accessor :config
    
    # initialise with config
  	def init_with_config(attributes = {})
      @config = Hash.new 
      file_config = YAML.load_file(attributes[:config])
      set_config :tasks, file_config[:run_tasks]
      set_config :raw_config_file, file_config
      set_config :app_name, file_config[:options][:app_name]
      set_config :build_dir, file_config[:options][:build_dir].nil? ? Dir.getwd + "/builds/" : file_config[:options][:build_dir]
      set_config :app_dir, file_config[:options][:app_dir].nil? ? "#{get_config :app_name}" : file_config[:options][:app_dir]
      set_config :icon_path, file_config[:options][:icon_path].nil? ? "../#{get_config :app_name}/Resources/Assets/Images/Icon/" : file_config[:options][:icon_path]
      set_config :scheme, file_config[:options][:scheme].nil? ? "App" : file_config[:options][:scheme]
      set_config :build_configuration, file_config[:options][:build_configuration].nil? ? nil : file_config[:options][:build_configuration]
      set_config :sdk, file_config[:options][:sdk].nil? ? "iphoneos" : file_config[:options][:sdk]
      set_config :code_sign, file_config[:options][:code_sign]
      set_config :provisioning_profile, file_config[:options][:provisioning_path].nil? ? "../Provisioning/#{file_config[:options][:provisioning_profile]}" : "#{file_config[:options][:provisioning_path]}#{file_config[:options][:provisioning_profile]}" 
      set_config :plist_path, (lambda do
        plist_file_paths = []
        Find.find("../#{get_config :app_dir}/SupportingFiles/") { |path| plist_file_paths << path if path =~ /.*\.plist$/ }
        plist_path = plist_file_paths.first.sub(' ', '\ ')
      end).call
      set_config :workspace, (lambda do
        ws_paths = []
        Find.find('../') { |path| ws_paths << path if path =~ /.*\.xcworkspace$/ unless path.include?('xcodeproj') }
        ws_path = ws_paths.first.sub(' ', '\ ')
      end).call
      puts "Build process initialised with configuration: \n\n"
      dump_config
    end
    
    # config set
    def set_config key, value
      @config[key] = value
    end
    
    # config get
    def get_config key
      @config[key]
    end
    
    # config debug
    def dump_config
      pp @config
    end
        
    # run tasks
    def run_tasks
      tasks_to_run = get_config :tasks
      tasks_to_run.each do |task, run|
        if run
          header_msg "Running Task: #{task}"
          ContiniOSIntegration.send task
        else
          header_msg "Skipping Task: #{task}"
        end
      end
    end
    
    # decoration
    def header_msg h
      puts "\n\n" + h + "\n" + ("-" * h.length) + "\n\n"
    end
    
    # on_completion
    def on_completion
      header_msg "Process completed!"
    end
    
    # terminate
    def terminate_with_err err
      puts "Terminating with error: #{err}"
      exit
    end
      
  end
      
end