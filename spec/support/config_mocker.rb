require 'yaml'

def valid_config
	{
		run_tasks: {
			increment_version: false,
  		decorate_icon: false,
  		xcode_build: false,
  		run_tests: false,
  		create_ipa: false
		},
		options: {
			app_name: "BuildKit",
  		workspace: "/Users/adamwaite/iOS/Lib/BuildKit/BuildKit Example Project/BuildKit.xcworkspace",
  		info_plist: "/Users/adamwaite/iOS/Lib/BuildKit/BuildKit Example Project/BuildKit/BuildKit-Info.plist",
  		build_configuration: "Release",
  		scheme: "BuildKit",
  		sdk: "iphoneos",
  		provisioning_profile: "/Users/adamwaite/iOS/Lib/BuildKit/BuildKit Example Project/Provisioning/BuildKitTest.mobileprovision",
  		code_sign: "iPhone Distribution: Alpaca Labs",
  		icon_dir: "/Users/adamwaite/iOS/Lib/BuildKit/BuildKit Example Project/BuildKit/Icon/",
  		build_dir: "/Users/adamwaite/iOS/Lib/BuildKit/BuildKit/specs/builds/"
		}
	}
end

def create_mock_config_file hash, file_name
	path = "specs/fixtures/#{file_name}.yml"
	File.open("specs/fixtures/#{file_name}.yml", 'w') { |f| f.write hash.to_yaml }
	path
end

def delete_all_mock_config_files
	Dir.glob("specs/fixtures/*.yml").each { |f| File.delete f }
end

def mock_config_file_path name
	File.join(__dir__, "../fixtures/#{name}.yml")
end

def deep_dup_config h
	Marshal.load(Marshal.dump(h))
end