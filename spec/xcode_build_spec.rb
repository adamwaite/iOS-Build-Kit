# require_relative 'spec_helper'

# describe "XCode Build Task" do

# 	context "invalid runners" do
# 		let(:xcode_build_enabled) { vc.enable_xcode_build }
# 		describe "required configuration" do 
# 			context "no app name" do
# 				let(:invalid) do 
# 					xcode_build_enabled[:configuration][:app_name] = nil
# 					xcode_build_enabled
# 				end
# 				let(:invalid_runner) { mock_runner invalid }
# 				specify { puts invalid; expect { invalid_runner.run_tasks! }.to raise_error }
# 			end
# 			context "no workspace" do
# 				let(:invalid) { vc.enable_xcode_build.merge({ configuration: { workspace: nil } }) }
# 				let(:invalid_runner) { mock_runner invalid }
# 				specify { expect { invalid_runner.run_tasks! }.to raise_error }
# 			end
# 			context "no sdk" do
# 				let(:invalid) { vc.enable_xcode_build.merge({ configuration: { sdk: nil } }) }
# 				let(:invalid_runner) { mock_runner invalid }
# 				specify { expect { invalid_runner.run_tasks! }.to raise_error }
# 			end
# 			context "no build_configuration" do
# 				let(:invalid) { vc.enable_xcode_build.merge({ configuration: { build_configuration: nil } }) }
# 				let(:invalid_runner) { mock_runner invalid }
# 				specify { expect { invalid_runner.run_tasks! }.to raise_error }
# 			end
# 			context "no build_dir" do
# 				let(:invalid) { vc.enable_xcode_build.merge({ configuration: { build_dir: nil } }) }
# 				let(:invalid_runner) { mock_runner invalid }
# 				specify { expect { invalid_runner.run_tasks! }.to raise_error }
# 			end
# 			context "no scheme" do
# 				let(:invalid) { vc.enable_xcode_build.merge({ configuration: { scheme: nil } }) }
# 				let(:invalid_runner) { mock_runner invalid }
# 				specify { expect { invalid_runner.run_tasks! }.to raise_error }
# 			end
# 			context "missing workspace" do
# 				let(:invalid) { vc.enable_xcode_build.merge({ configuration: { workspace: "/nope/" } }) }
# 				let(:invalid_runner) { mock_runner invalid }
# 				specify { expect { invalid_runner.run_tasks! }.to raise_error }
# 			end
# 			context "missing build_dir" do
# 				let(:invalid) { vc.enable_xcode_build.merge({ configuration: { build_dir: "/nope/" } }) }
# 				let(:invalid_runner) { mock_runner invalid }
# 				specify { expect { invalid_runner.run_tasks! }.to raise_error }
# 			end
# 		end
# 	end

# 	context "valid runners" do
# 		let(:runner) { mock_runner vc }
# 		describe "successful build" do
# 		  before { runner.run_tasks! }
# 		  specify { runner.store[:xcode_build_succeeded].should be_true }
# 		end

# 		pending "one day create a failing target and test that runner.store[:xcode_build_succeeded].should_not be_true"

# 		describe "task completion" do
# 		  before { runner.run_tasks! }
# 			specify { runner.tasks[:completed].include?(:xcode_build).should be_true }
# 			specify { runner.outputs[:xcode_build].should_not be_nil }
# 		end
# 	end

# end