require_relative 'spec_helper'

describe "run_tests task" do
  
	describe "invalid config handling" do
		context "missing configuration" do
			context "workspace" do
				let(:runner) { mock_runner vc.enable_run_tests!.remove_config! :workspace }
				specify { expect { runner.run_tasks! }.to raise_error }
			end
			context "scheme" do
				let(:runner) { mock_runner vc.enable_run_tests!.remove_config! :scheme }
				specify { expect { runner.run_tasks! }.to raise_error }
			end
		end
		context "non-existent files" do
			context "workspace" do
				let(:runner) { mock_runner vc.enable_run_tests!.invalid_location! :workspace }
				specify { expect { runner.run_tasks! }.to raise_error }
			end
		end
	end

	describe "passing tests" do
	  let(:runner) { mock_runner vc.enable_run_tests! }
	  before { runner.run_tasks! }
	  specify { runner.store[:tests_passed].should be_true }
	end

	describe "failing tests" do
	  pending "Create a failing test target, compare YES to NO or something"
	end

	describe "task completion" do
		let(:runner) { mock_runner vc.enable_run_tests! }
	  before { runner.run_tasks! }
		specify { runner.tasks[:completed].include?(:run_tests).should be_true }
		specify { runner.outputs[:run_tests].should_not be_nil }
	end

end