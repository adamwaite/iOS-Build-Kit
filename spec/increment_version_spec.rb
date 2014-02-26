require_relative 'spec_helper'

describe "xcode_build task" do
  
	describe "invalid config handling" do
	  
		context "missing configuration" do

			context "info_plist" do
				let(:runner) { mock_runner vc.enable_increment_version!.remove_config! :info_plist }
				specify { expect { runner.run_tasks! }.to raise_error }
			end

		end
		
		context "non-existent files" do

			context "info_plist" do
				let(:runner) { mock_runner vc.enable_increment_version!.missing_file! :info_plist }
				specify { expect { runner.run_tasks! }.to raise_error }
			end

		end

	end

	describe "plist reading" do
		let(:runner) { mock_runner vc.enable_increment_version! }
		specify { BuildKit::Utilities::VersionNumber.plist_version_number(runner.config.info_plist).should be_kind_of Hash }
		specify { BuildKit::Utilities::VersionNumber.plist_version_number(runner.config.info_plist)[:major].should be_kind_of Integer }
		specify { BuildKit::Utilities::VersionNumber.plist_version_number(runner.config.info_plist)[:minor].should be_kind_of Integer }
		specify { BuildKit::Utilities::VersionNumber.plist_version_number(runner.config.info_plist)[:revision].should be_kind_of Integer }
		specify { BuildKit::Utilities::VersionNumber.plist_version_number(runner.config.info_plist)[:build].should be_kind_of Integer }
	end

	describe "existing version" do
	  let(:runner) { mock_runner vc.enable_increment_version! }
	  let!(:existing_version) { BuildKit::Utilities::VersionNumber.plist_version_number(runner.config.info_plist) }
	  before { runner.run_tasks! }
	  specify { runner.store[:existing_version_number].should == existing_version }
	end

	describe "new version" do
	  let(:runner) { mock_runner vc.enable_increment_version! }
	  before { runner.run_tasks! }
	  specify { runner.store[:new_version_number].should_not be_nil }
	end

	describe "it increments the build number" do
	  let(:runner) { mock_runner vc.enable_increment_version! }
	  let!(:existing_build_number) { BuildKit::Utilities::VersionNumber.plist_version_number(runner.config.info_plist)[:build] }
	  before { runner.run_tasks! }
	  specify { runner.store[:new_version_number][:build].should == existing_build_number + 1 }
	end

	describe "writing the new version to the plist" do
		let(:runner) { mock_runner vc.enable_increment_version! }
	  let!(:existing_build_number) { BuildKit::Utilities::VersionNumber.plist_version_number(runner.config.info_plist)[:build] }
	  before { runner.run_tasks! }
	  specify { BuildKit::Utilities::VersionNumber.plist_version_number(runner.config.info_plist)[:build].should == existing_build_number + 1 }
	end

	describe "task completion" do
		let(:runner) { mock_runner vc.enable_increment_version! }
	  before { runner.run_tasks! }
		specify { runner.tasks[:completed].include?(:increment_version).should be_true }
		specify { runner.outputs[:increment_version].should_not be_nil }
	end

end