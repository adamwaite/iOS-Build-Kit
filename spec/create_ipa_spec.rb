require_relative 'spec_helper'

describe "create_ipa task" do
  
	describe "invalid config handling" do
		context "missing previous tasks" do
			context "xcode_build" do
				let(:runner) { mock_runner vc.enable_create_ipa! }
				specify { expect { runner.run_tasks! }.to raise_error }
			end
		end
	end

	describe "ipa creation" do		
		let!(:existing_ipa_exists) { (Dir["#{runner.config.build_dir}/*"].reject{ |f| !f.include? ".ipa" }.count > 0) }
		let(:runner) { mock_runner vc.enable_xcode_build!.enable_create_ipa! }
		before { runner.run_tasks! }
		specify { existing_ipa_exists.should be_false }
		specify { Dir["#{runner.config.build_dir}/*"].reject{ |f| !f.include? ".ipa" }.count.should == 1 }
	end

	describe "task completion" do
		let(:runner) { mock_runner vc.enable_xcode_build!.enable_create_ipa! }
		before { runner.run_tasks! }
		specify { runner.tasks[:completed].include?(:create_ipa).should be_true }
		specify { runner.outputs[:create_ipa].should_not be_nil }
	end

end