module ContiniOSIntegration
  
  def self.xcode_build
    
    # config
    runner = ContiniOSIntegration::CITaskRunner.instance
    
    # app name argument
    app_name = runner.get_config :app_name
    
    # handle undefined requirements
    runner.terminate_with_err "An app name must be specified in the config options to run xcode_build" if app_name.nil?
    		  
    # workspace argument
    workspace_arg = "-workspace #{runner.get_config :workspace}"
    
    # SDK argument
    sdk = runner.get_config :sdk
    sdk_arg = "-sdk #{sdk}"
    
    # scheme argument
		scheme = runner.get_config :scheme
    scheme_arg = "-scheme #{scheme}"
    
    # configuration argument
		configuration = runner.get_config :build_configuration
    configuration_arg = configuration.nil? ? "" : "-configuration #{configuration}"
		
    # build directory argument
    build_dir = runner.get_config :build_dir
    build_dir_arg = "CONFIGURATION_BUILD_DIR=\"#{build_dir}\""
        
    # perform build
		system "xctool #{workspace_arg} #{sdk_arg} #{scheme_arg} #{configuration_arg} #{build_dir_arg} build"
  
  end
  
end