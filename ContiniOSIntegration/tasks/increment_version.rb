module ContiniOSIntegration
    
  def self.increment_version
		   
    # config
    runner = ContiniOSIntegration::CITaskRunner.instance
    
    # requirements
    runner.ensure_required_config [:plist_path]
    
    # plist path
    plist_path = runner.get_config :plist_path
                
    # pull version from plist file
    version = %x[/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" #{plist_path}]
    build_number = %x[/usr/libexec/PlistBuddy -c "Print CFBundleVersion" #{plist_path}].to_i
    
    # split the version into components
		split_version = version.split(".").map { |s| s.to_i }
		major = split_version[0].nil? ? 0 : split_version[0]
		minor = split_version[1].nil? ? 0 : split_version[1]
		revision = split_version[2].nil? ? 0 : split_version[2]
    major_minor_split_version = [major, minor, revision].join(".")
    old_version = [major_minor_split_version, build_number].join(".")
    
    # increment the version
    build_number = build_number + 1
    new_version = [major, minor, revision, build_number].join(".")
    
    # save
    runner.set_config :new_version_number, new_version
		
    # write the new version numbers to the plist
    system "/usr/libexec/PlistBuddy -c \"Set :CFBundleShortVersionString #{major_minor_split_version}\" #{plist_path}"
    system "/usr/libexec/PlistBuddy -c \"Set :CFBundleVersion #{build_number}\" #{plist_path}"
	  
    # notify
  	puts "incremented version number from #{old_version} to #{new_version}"
  
  end
  
end