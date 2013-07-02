module ContiniOSIntegration
    
  def self.existing_version_number
    
    runner = ContiniOSIntegration::CITaskRunner.instance
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
    existing_version = [major_minor_split_version, build_number].join(".")
  
    { :major => major, :minor => minor, :revision => revision, :build => build_number, :major_minor_split => major_minor_split_version, :full => existing_version }
      
  end

end