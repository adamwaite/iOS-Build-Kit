module ContiniOSIntegration
  
  require "./utils/existing_version_number.rb"
  
  def self.create_ipa
    
    # instance
    runner = ContiniOSIntegration::CITaskRunner.instance
    
    # requirements
    runner.ensure_required_config [:sdk, :build_dir, :code_sign, :provisioning_profile, :plist_path, :xcode_build_task_executed]
    
    # app data arguments
    app_name = runner.get_config :app_name
    		
    # SDK argument
    sdk = runner.get_config :sdk
    sdk_arg = "-sdk #{sdk}"
		
    # build and output dir arguments
    build_dir = output_dir = runner.get_config(:build_dir)
    
    # code sign and provisioning arguments
    code_sign = runner.get_config :code_sign
    prov_profile = runner.get_config :provisioning_profile
    
    #version number for file name
    if runner.get_config(:new_version_number).nil?
      existing_version = existing_version_number
      v_no = existing_version[:full]
    else
      v_no = runner.get_config :new_version_number
    end
    
    # output file name
    output_file_name = "#{app_name}-#{v_no}.ipa"
    output_file = "#{output_dir}#{output_file_name}"
        
    # check existence of output filename in case of overwrite
    ipa_exists_already = (lambda do
      build_dir = runner.get_config(:build_dir)
      does_exist = false
      Dir.foreach(build_dir) { |f| does_exist = true if f.include? "#{output_file_name}" }
      does_exist
    end).call
    existing_file_was_modified_at = File.stat("#{output_file}").mtime if ipa_exists_already
        
    # .ipa count lambda
    count_ipas = lambda do
      build_dir = runner.get_config :build_dir
      ipa_files = []
      Dir.foreach(build_dir) { |f| ipa_files << f if f.include? ".ipa" }
      ipa_files.count
    end
    
    # count existing .ipa files
    existing_ipa_count = count_ipas.call 
    
    # package the app
		system "/usr/bin/xcrun #{sdk_arg} PackageApplication -v #{build_dir}#{app_name}.app -o #{output_file} --sign \"#{code_sign}\" --embed \"#{prov_profile}\""
    
    # check if a new file was saved or an existing file was overwritten
    new_ipa_count = count_ipas.call
    potential_new_file_was_modified_at = File.stat("#{output_file}").mtime if ipa_exists_already
    was_overwritten = ((existing_file_was_modified_at != potential_new_file_was_modified_at) and !existing_file_was_modified_at.nil?)
    new_ipa_was_saved = (new_ipa_count <= existing_ipa_count) or was_overwritten
    
    # warn if overwrite
    puts "\nnote: an existing build artefact was updated" if was_overwritten
    
    # warn if .ipa was not generated
    runner.terminate_with_err "The .ipa file was not generated successfully, explore the output for the issue" unless new_ipa_was_saved
    
    # success otherwise
    runner.success_msg "build artefact generated successfully, it's here -> #{output_file}"
    
  end
  
end