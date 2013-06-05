module ContiniOSIntegration
  
  def self.create_ipa
    
    # config
    runner = ContiniOSIntegration::CITaskRunner.instance
    config = runner.config
        
    # handle nil required parameters    
    runner send terminate_with_err "a code signing identity must be provided to package an iOS app" if config[:options][:code_sign].nil?
    runner send terminate_with_err "a provisioning profile path must be provided to package an iOS app" if config[:options][:provisioning_profile].nil?
    
    # app data arguments
    app_name = config[:options][:app_name]
    new_version_number = runner.new_version_number
		
    # SDK argument
    sdk = "iphoneos"
    sdk_arg = "-sdk #{sdk}"
		
    # build and output dir arguments
    build_dir = output_dir = runner.build_dir
    
    # code sign and provisioning arguments
    code_sign = config[:options][:code_sign]
		prov_profile = "../Provisioning/#{config[:options][:provisioning_profile]}"
      
    # package the app
		system "/usr/bin/xcrun #{sdk_arg} PackageApplication -v #{build_dir}#{app_name}.app -o #{output_dir}#{app_name}-#{new_version_number}.ipa --sign \"#{code_sign}\" --embed \"#{prov_profile}\""

  end
  
end