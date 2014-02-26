require_relative 'spec_helper'

describe "xcode_build task" do
  
	describe "invalid config handling" do
	  
		context "missing configuration" do
			context "app_name" do
				let(:runner) { mock_runner vc.enable_xcode_build!.remove_config! :app_name }
				specify { expect { runner.run_tasks! }.to raise_error }
			end
			context "workspace" do
				let(:runner) { mock_runner vc.enable_xcode_build!.remove_config! :workspace }
				specify { expect { runner.run_tasks! }.to raise_error }
			end
			context "build_configuration" do
				let(:runner) { mock_runner vc.enable_xcode_build!.remove_config! :build_configuration }
				specify { expect { runner.run_tasks! }.to raise_error }
			end
			context "build_dir" do
				let(:runner) { mock_runner vc.enable_xcode_build!.remove_config! :build_dir }
				specify { expect { runner.run_tasks! }.to raise_error }
			end
			context "scheme" do
				let(:runner) { mock_runner vc.enable_xcode_build!.remove_config! :scheme }
				specify { expect { runner.run_tasks! }.to raise_error }
			end
		end
		
		context "non-existent files" do
			context "workspace" do
				let(:runner) { mock_runner vc.enable_xcode_build!.missing_file!(:workspace) }
				specify { expect { runner.run_tasks! }.to raise_error }
			end
			context "build_dir" do
				let(:runner) { mock_runner vc.enable_xcode_build!.invalid_location!(:build_dir) }
				specify { expect { runner.run_tasks! }.to raise_error }
			end
		end

	end

	describe "successful build" do
	  let(:runner) { mock_runner(vc.enable_xcode_build!) }
	  before { runner.run_tasks! }
	  specify { runner.store[:xcode_build_succeeded].should be_true }
	end

	describe "failing build" do
	  pending "create a target that fails to build, spelling mistake or something"
	end

	describe "task completion" do
		let(:runner) { mock_runner(vc.enable_xcode_build!) }
		before { runner.run_tasks! }
		specify { runner.tasks[:completed].include?(:xcode_build).should be_true }
		specify { runner.outputs[:xcode_build].should_not be_nil }
	end

end