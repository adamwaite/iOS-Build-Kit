module ContiniOSIntegration
  
  def self.increment_version
		
    # config
    runner = ContiniOSIntegration::CITaskRunner.instance
    plist_path = runner.get_config :plist_path
                
    # pull version from plist file
    version = %x[/usr/libexec/PlistBuddy -c "Print CFBundleVersion" #{plist_path}]
    
    # split the version into components
		split_version = version.split(".").map { |s| s.to_i }
		major = split_version[0].nil? ? 1 : split_version[0]
		minor = split_version[1].nil? ? 0 : split_version[1]
		revision = split_version[2].nil? ? 0 : split_version[2]
		build = split_version[3].nil? ? 0 : split_version[3]
    
    # increment the version
		old_version = [major, minor, revision, build].join(".")
		build = build + 1
    new_version = [major, minor, revision, build].join(".")
    
    # save
    runner.set_config :new_version_number, new_version
		
    # write the new version to the plist
    system "/usr/libexec/PlistBuddy -c \"Set :CFBundleVersion #{new_version}\" #{plist_path}"
	  
    # notify
  	puts "incremented build from #{old_version} to #{new_version}"
  
  end
  
end