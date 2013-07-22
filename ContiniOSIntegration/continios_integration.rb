module ContiniOSIntegration
  
  # task runner instance
  class CITaskRunner
    
    # ensure single task running instance
    require 'singleton'
    include Singleton
    
    # require tasks and utilities
    require 'YAML'
    require 'find'
    require 'pp'
    Dir["./tasks/*.rb"].each {|file| require file }
    
    # accesssors
    attr_accessor :config, :running_task
    
    # initialise with config
    def init_with_config(attributes = {})
      @config = Hash.new
      terminate_with_err "config file does not exist!" unless File.exists? attributes[:config]
      file_config = YAML.load_file(attributes[:config])
      containing_dir = File.expand_path("..",Dir.pwd)
      set_config :raw_config_file, file_config
      set_config :tasks, file_config[:run_tasks]
      set_config :app_name, file_config[:options][:app_name]
      set_config :app_dir, file_config[:options][:app_dir].nil? ? "#{containing_dir}/#{get_config :app_name}/#{get_config :app_name}" : file_config[:options][:app_dir]
      set_config :build_dir, file_config[:options][:build_dir].nil? ? Dir.getwd + "/builds/" : file_config[:options][:build_dir]
      set_config :icon_path, file_config[:options][:icon_path].nil? ? "#{get_config :app_dir}/Resources/Assets/Images/Icon/" : file_config[:options][:icon_path]
      set_config :scheme, file_config[:options][:scheme].nil? ? "App" : file_config[:options][:scheme]
      set_config :build_configuration, file_config[:options][:build_configuration].nil? ? "Release" : file_config[:options][:build_configuration]
      set_config :sdk, file_config[:options][:sdk].nil? ? "iphoneos" : file_config[:options][:sdk]
      set_config :code_sign, file_config[:options][:code_sign]
      default_pp_path = "#{containing_dir}/#{get_config :app_name}/Provisioning/#{file_config[:options][:provisioning_profile]}"
      set_config :provisioning_profile, file_config[:options][:provisioning_path].nil? ? default_pp_path : "#{file_config[:options][:provisioning_path]}#{file_config[:options][:provisioning_profile]}" 
      set_config :plist_path, (lambda do
        plist_file_paths = []
        plist_loc = "#{get_config :app_dir}/SupportingFiles/"
        Find.find(plist_loc) { |path| plist_file_paths << path if path =~ /.*\.plist$/ }
        plist_path = plist_file_paths.first.sub(' ', '\ ')
      end).call
      set_config :workspace, (lambda do
        ws_paths = []
        ws_loc = "../#{get_config :app_name}"
        Find.find(ws_loc) { |path| ws_paths << path if path =~ /.*\.xcworkspace$/ unless path.include?('xcodeproj') }
        ws_path = ws_paths.first.sub(' ', '\ ')
      end).call
      list_config
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
    def list_config
      puts "Config:\n\n"
      pp @config
    end
    
    # config debug
    def list_config_keys
      puts "\nConfig Keys:\n\n"
      @config.each { |key, value| puts key }
    end
    
    # ensures config requirements before running a task
    def ensure_required_config req_keys
      req_keys.each do |k|
        terminate_with_err "#{k} is required to run #{@running_task}" if get_config(k).nil?
      end
    end
        
    # run tasks
    def run_tasks
      tasks_to_run = get_config :tasks
      tasks_to_run.each do |task, run|
        if run
          @running_task = task
          header_msg "Running Task: #{task}"
          ContiniOSIntegration.send task
        else
          header_msg "Skipping Task: #{task}"
        end
      end
    end
    
    # decoration
    def header_msg h
      puts "\n\n" + h + "\n" + ("-" * h.length) + "\n"
    end
    
    # successful task execution
    def success_msg m
      puts "\n#{m}\n"
    end
    
    # on_completion
    def on_completion
      success_msg "All tasks succeeded!"
    end
    
    # terminate
    def terminate_with_err err
      puts "\nTerminating with error: #{err}\n\n"
      exit
    end
      
  end
      
end