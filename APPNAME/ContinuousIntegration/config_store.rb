module ContiniOSIntegration
  
  def self.xcode_build
    
    # config
    runner = ContiniOSIntegration::CITaskRunner.instance
    config = runner.config
    
    # app name argument
    app_name = runner.app_name
    
    # handle undefined requirements
    runner.terminate_with_err "An app name must be specified in the config options to run xcode_build" if runner.app_name.nil?
    		  
    # workspace argument
    workspace_arg = "-workspace #{runner.workspace}"
    
    # SDK argument
    sdk = "iphoneos"
    sdk_arg = "-sdk #{sdk}"
    
    # scheme argument
		scheme = config[:options][:scheme].nil? ? app_name : config[:options][:scheme]
    scheme_arg = "-scheme #{scheme}"
    
    # configuration argument
		configuration = config[:options][:configuration].nil? ? nil : config[:options][:configuration]
    configuration_arg = configuration.nil? ? "" : "-configuration #{configuration}"
		
    # build directory argument
    build_dir = runner.build_dir
    build_dir_arg = "CONFIGURATION_BUILD_DIR=\"#{build_dir}\""
        
    # perform build
		system "xctool #{workspace_arg} #{sdk_arg} #{scheme_arg} #{configuration_arg} #{build_dir_arg} build"
  
  end
  
end