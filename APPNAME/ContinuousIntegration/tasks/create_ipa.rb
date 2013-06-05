module ContiniOSIntegration
  
  def self.create_ipa
    
    # config
    runner = ContiniOSIntegration::CITaskRunner.instance
        
    # app data arguments
    app_name = runner.get_config :app_name
    new_version_number = runner.get_config :new_version_number
		
    # SDK argument
    sdk = runner.get_config :sdk
    sdk_arg = "-sdk #{sdk}"
		
    # build and output dir arguments
    build_dir = output_dir = runner.get_config :build_dir
    
    # code sign and provisioning arguments
    code_sign = runner.get_config :code_sign
    prov_profile = runner.get_config :provisioning_profile
      
    # output file name  
    output_file_name = new_version_number.nil? ? "#{output_dir}#{app_name}-#{new_version_number}.ipa" : "#{output_dir}#{app_name}.ipa"
    
    # package the app
		system "/usr/bin/xcrun #{sdk_arg} PackageApplication -v #{build_dir}#{app_name}.app -o #{output_file_name} --sign \"#{code_sign}\" --embed \"#{prov_profile}\""
    
  end
  
end