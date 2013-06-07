module ContiniOSIntegration
  
  def self.xcode_build
    
    # instance
    runner = ContiniOSIntegration::CITaskRunner.instance
    
    # requirements
    runner.ensure_required_config [:app_name, :workspace, :sdk, :build_configuration, :build_dir]
    
    # app name argument
    app_name = runner.get_config :app_name    
      		  
    # workspace argument
    ws = runner.get_config :workspace
    workspace_arg = "-workspace #{ws}"
    
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
    
    # success message
    runner.success_msg "xcode_build completed successfully"
    
    # set flag for future tasks
    runner.set_config :xcode_build_task_executed, true
  
  end
  
end