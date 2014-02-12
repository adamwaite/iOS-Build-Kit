# require_relative 'spec_helper'

# describe "Increment version" do

# 	context "invalid runners" do
# 		describe "required configuration" do 
# 			context "no info plist" do
# 				let(:invalid) { vc.enable_increment_version.merge({ configuration: { info_plist: nil } }) }
# 				let(:invalid_runner) { mock_runner invalid }
# 				specify { expect { invalid_runner.run_tasks! }.to raise_error }
# 			end

# 			context "invalid info plist" do
# 				let(:invalid) { vc.enable_increment_version.merge({ configuration: { info_plist: "/nope/" } }) }
# 				let(:invalid_runner) { mock_runner invalid }
# 				specify { expect { invalid_runner.run_tasks! }.to raise_error }
# 			end
# 		end
# 	end
	
# 	context "valid runners" do
# 		let(:runner) { mock_runner vc.enable_increment_version }
# 		let(:plist_path) { valid_config_file_data[:configuration][:info_plist] }
# 		let!(:version_number) { BuildKit::Utilities::PlistPal.read_value_in_plist(plist_path, "CFBundleShortVersionString") }
# 		let!(:build_number) { BuildKit::Utilities::PlistPal.read_value_in_plist(plist_path, "CFBundleVersion") }

# 		describe "plist reading" do		
# 			specify { version_number.should be_kind_of String }
# 			specify { build_number.to_i.should be_kind_of Integer }
# 		end

# 		describe "existing version" do
# 		  before { runner.run_tasks! }
# 		  specify { runner.store[:existing_version_number].should be_kind_of Hash }
# 		end

# 		describe "new version" do
# 		  before { runner.run_tasks! }
# 		  specify { runner.store[:new_version_number].should be_kind_of Hash }
# 		end

# 		describe "writing the new version to the plist" do
# 			before { runner.run_tasks! }	
# 			specify { BuildKit::Utilities::PlistPal.read_value_in_plist(plist_path, "CFBundleVersion").to_i.should == (build_number.to_i + 1) }
# 		end
	
# 		describe "task completion" do
# 		  before { runner.run_tasks! }	
# 			specify { runner.tasks[:completed].include?(:increment_version).should be_true }
# 			specify { runner.outputs[:increment_version].should_not be_nil }
# 		end

# 	end

# end