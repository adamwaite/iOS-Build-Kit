# require_relative 'spec_helper'

# describe "BuildKit" do

# 	before(:all) do

# 		valid_xcode_build_config = valid_config
# 		valid_xcode_build_config[:run_tasks][:xcode_build] = true
# 		create_mock_config_file valid_xcode_build_config, "valid"

# 		missing_app_name_option_hash = deep_dup_config valid_xcode_build_config
# 		missing_app_name_option_hash[:options][:app_name] = nil
# 		create_mock_config_file missing_app_name_option_hash, "nil_option"

# 		non_existing_workspace_hash = deep_dup_config valid_xcode_build_config
# 		non_existing_workspace_hash[:options][:workspace] = "/Path/To/Somewhere/That/Does/Not/Exist/app.workspace"
# 		create_mock_config_file non_existing_workspace_hash, "missing"

# 	end

# 	after(:all) do
# 		delete_all_mock_config_files
# 		clear_reports
# 	end

# 	describe "xcode_build" do

# 		before(:each) { Singleton.__init__(BuildKit::Runner) }

# 		let(:runner) { BuildKit::Runner.instance }
# 		let!(:mock_valid_config_file) { mock_config_file_path "valid" }
# 		let!(:mock_missing_required_option_config_file) { mock_config_file_path "nil_option" }
# 		let!(:mock_non_existent_file_config_file) { mock_config_file_path "missing" }

# 		describe "required config and files" do
# 			it "checks assert_required_config" do
# 				BuildKit.should_receive(:assert_required_config).with([:app_name, :workspace, :sdk, :build_configuration, :build_dir, :scheme])
# 				runner.configure(config: mock_valid_config_file)
# 				runner.run_tasks
# 			end
# 			it "checks assert_files_exist" do
# 				runner.configure(config: mock_valid_config_file)
# 				BuildKit.should_receive(:assert_files_exist).with([valid_config[:options][:workspace], valid_config[:options][:build_dir]])
# 				runner.run_tasks
# 			end
# 			context "empty required parameters" do
# 				before { runner.configure(config: mock_missing_required_option_config_file) }
# 				specify { expect { runner.run_tasks }.to raise_error }
# 			end
# 			context "non existent workspace" do
# 				before { runner.configure(config: mock_non_existent_file_config_file) }
# 				specify { expect { runner.run_tasks }.to raise_error }
# 			end
# 		end

# 		describe "successful build" do
# 		  before do
# 		  	runner.configure(config: mock_valid_config_file)
# 				runner.run_tasks
# 		  end
# 		  specify { runner.store[:xcode_build_succeeded].should be_true }
# 		end

# 		pending "one day create a failing target and test that runner.store[:xcode_build_succeeded].should_not be_true"

# 		describe "task completion" do
# 		  before do
# 				runner.configure(config: mock_valid_config_file)
# 				runner.run_tasks
# 			end
# 			specify { runner.tasks[:completed].include?(:xcode_build).should be_true }
# 			specify { runner.outputs[:xcode_build].should_not be_nil }
# 		end

# 	end

# end