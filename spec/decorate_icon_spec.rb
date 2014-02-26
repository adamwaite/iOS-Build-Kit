require_relative 'spec_helper'

describe "decorate_icon task" do
  
	describe "invalid config handling" do
	  
		context "missing configuration" do

			context "icon_dir" do
				let(:runner) { mock_runner vc.enable_decorate_icon!.remove_config! :icon_dir }
				specify { expect { runner.run_tasks! }.to raise_error }
			end

		end
		
		context "non-existent files" do

			context "icon_dir" do
				let(:runner) { mock_runner vc.enable_decorate_icon!.invalid_location! :icon_dir }
				specify { expect { runner.run_tasks! }.to raise_error }
			end

		end

	end

	describe "new icons" do		
		pending "the icon dir has as many new files of type png as there was beforehand"
	end

	describe "task completion" do
		let(:runner) { mock_runner vc.enable_decorate_icon! }
		before { runner.run_tasks! }
		specify { runner.tasks[:completed].include?(:decorate_icon).should be_true }
		specify { runner.outputs[:decorate_icon].should_not be_nil }
	end

end