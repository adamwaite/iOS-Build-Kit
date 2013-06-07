module ContiniOSIntegration
  
  def self.run_tests
    
    # instance
    runner = ContiniOSIntegration::CITaskRunner.instance
    
    # requirements
    runner.ensure_required_config [:workspace, :scheme]
    
    # kill any hanging instance of the simulator
    system "killall -m -KILL \"iPhone Simulator\""
        
    # config
    runner = ContiniOSIntegration::CITaskRunner.instance
  		  
    # workspace argument
    workspace_arg = "-workspace #{runner.get_config :workspace}"
  
    # scheme argument
		scheme = runner.get_config :scheme
    scheme_arg = "-scheme #{scheme}"
  
    # perform build
		system "xctool #{workspace_arg} #{scheme_arg} test"
    
    # success message
    runner.success_msg "run_tests completed successfully"
    
  end
  
end