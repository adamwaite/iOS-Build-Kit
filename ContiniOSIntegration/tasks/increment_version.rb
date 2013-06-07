module ContiniOSIntegration
    
  require "./utils/existing_version_number.rb"
  
  def self.increment_version
		   
    # instance
    runner = ContiniOSIntegration::CITaskRunner.instance
    
    # requirements
    runner.ensure_required_config [:plist_path]
    
    # plist path
    plist_path = runner.get_config :plist_path
    existing_version = existing_version_number
      
    # increment the version
    build_number = existing_version[:build] + 1
    new_version = [existing_version[:major_minor_split], build_number].join(".")
    
    # save
    runner.set_config :new_version_number, new_version
		
    # write the new version numbers to the plist
    system "/usr/libexec/PlistBuddy -c \"Set :CFBundleShortVersionString #{existing_version[:major_minor_split]}\" #{plist_path}"
    system "/usr/libexec/PlistBuddy -c \"Set :CFBundleVersion #{build_number}\" #{plist_path}"
	  
    # notify
  	puts "old version number: #{existing_version[:full]}"
    puts "new version number: #{new_version}"
    runner.success_msg "incremented version number from #{existing_version[:full]} to #{new_version} and written to plist successfully"
  
  end
  
end