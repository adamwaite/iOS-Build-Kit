require_relative 'spec_helper'

describe "BuildKit" do

	before(:all) do
		
		valid_run_tests_config = valid_config
		valid_run_tests_config[:run_tasks][:run_tests] = true
		create_mock_config_file valid_run_tests_config, "valid"
		
		missing_scheme_name_option_hash = deep_dup_config valid_run_tests_config
		missing_scheme_name_option_hash[:options][:scheme] = nil
		create_mock_config_file missing_scheme_name_option_hash, "nil_option"

		non_existing_workspace_hash = deep_dup_config valid_run_tests_config
		non_existing_workspace_hash[:options][:workspace] = "/Path/To/Somewhere/That/Does/Not/Exist/app.workspace"
		create_mock_config_file non_existing_workspace_hash, "missing"

	end

	after(:all) do
		delete_all_mock_config_files
		clear_reports
	end

	describe "run_tests" do

		before(:each) { Singleton.__init__(BuildKit::Runner) }

		let(:runner) { BuildKit::Runner.instance }
		let!(:mock_valid_config_file) { mock_config_file_path "valid" }
		let!(:mock_missing_required_option_config_file) { mock_config_file_path "nil_option" }
		let!(:mock_non_existent_file_config_file) { mock_config_file_path "missing" }

		describe "required config and files" do
			it "checks assert_required_config" do
				BuildKit.should_receive(:assert_required_config).with([:workspace, :scheme])
				runner.configure(config: mock_valid_config_file)
				runner.run_tasks
			end
			it "checks assert_files_exist" do
				runner.configure(config: mock_valid_config_file)
				BuildKit.should_receive(:assert_files_exist).with([valid_config[:options][:workspace]])
				runner.run_tasks
			end
			context "empty plist" do
				before { runner.configure(config: mock_missing_required_option_config_file) }
				specify { expect { runner.run_tasks }.to raise_error }
			end
			context "plist does not exist" do
				before { runner.configure(config: mock_non_existent_file_config_file) }
				specify { expect { runner.run_tasks }.to raise_error }
			end
		end

		describe "passing tests" do
		  before do
		  	runner.configure(config: mock_valid_config_file)
				runner.run_tasks
		  end
		  specify { runner.store[:tests_passed].should be_true }
		end

		pending "one day create a failing test and test that runner.store[:run_tests_succeeded].should_not be_true"

		describe "task completion" do
		  before do
				runner.configure(config: mock_valid_config_file)
				runner.run_tasks
			end
			specify { runner.tasks[:completed].include?(:run_tests).should be_true }
			specify { runner.outputs[:run_tests].should_not be_nil }
		end

	end

end