module ContiniOSIntegration
  
  # task runner instance
  class CITaskRunner
    
    # ensure single task running instance
    require 'singleton'
    include Singleton
    
    # require tasks and utilities
    require 'find'
    Dir["./tasks/*.rb"].each {|file| require file }
    
    # accesssors
    attr_accessor :config, :app_name, :build_dir, :plist_path, :new_version_number, :app_dir, :workspace
    
    # initialise with config
  	def init_with_config(attributes = {})
      @config = YAML.load_file(attributes[:config])
      puts "Initialised with configuration file: #{attributes[:config]}"
      @app_name = @config[:options][:app_name]
      @build_dir = (@config[:options][:build_dir].nil?) ? Dir.getwd + "/builds/" : @config[:options][:build_dir]
      @app_dir = (@config[:options][:app_dir].nil?) ? "#{app_name}" : @config[:options][:app_dir]
      @plist_path = lambda do
        plist_file_paths = []
        Find.find("../#{@app_dir}/SupportingFiles/") { |path| plist_file_paths << path if path =~ /.*\.plist$/ }
        plist_path = plist_file_paths.first.sub(' ', '\ ')
      end.call
      @workspace = lambda do
        ws_paths = []
        Find.find('../') { |path| ws_paths << path if path =~ /.*\.xcworkspace$/ unless path.include?('xcodeproj') }
        ws_path = ws_paths.first.sub(' ', '\ ')
      end.call
      
      puts "Configuration:"
      puts self.inspect
      
    end
        
    # run tasks
    def run_tasks
      @config[:run_tasks].each do |task, run|
        puts
        if run
          puts "Running Task: #{task}"
          ContiniOSIntegration.send task
        else
          puts "Skipping Task: #{task}"
        end
      end
    end
    
    def on_completion
      puts "Process completed!"
    end
    
    # terminate
    def terminate_with_err err
      puts "Terminating with error: #{err}"
      exit
    end
      
  end
      
end