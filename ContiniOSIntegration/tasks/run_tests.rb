module ContiniOSIntegration
  
  def self.run_tests
    
    # kill any hanging instance of the simulator
    system "killall -m -KILL \"iPhone Simulator\""
    
    # config
    runner = ContiniOSIntegration::CITaskRunner.instance
  		  
    # workspace argument
    workspace_arg = "-workspace #{runner.get_config :workspace}"
  
    # scheme argument
		scheme = runner.get_config :scheme
    scheme_arg = "-scheme #{scheme}"
  
    # configuration argument
		configuration = runner.get_config :scheme
    configuration_arg = configuration.nil? ? "" : "-configuration #{configuration}"
	
    # build directory argument
    build_dir = runner.get_config :build_dir
    build_dir_arg = "CONFIGURATION_BUILD_DIR=\"#{build_dir}\""
      
    # perform build
		system "xctool #{workspace_arg} #{scheme_arg} test"
            
  end
  
end