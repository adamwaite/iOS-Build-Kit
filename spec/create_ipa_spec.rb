# require_relative 'spec_helper'

# describe "BuildKit" do

# 	before(:all) do

# 		valid_create_ipa_config = valid_config
# 		valid_create_ipa_config[:run_tasks][:xcode_build] = true
# 		valid_create_ipa_config[:run_tasks][:create_ipa] = true
# 		create_mock_config_file valid_create_ipa_config, "valid"

# 		missing_options_hash = deep_dup_config valid_create_ipa_config
# 		missing_options_hash[:options][:build_dir] = nil
# 		create_mock_config_file missing_options_hash, "nil_option"

# 		non_existing_profile_hash = deep_dup_config valid_create_ipa_config
# 		non_existing_profile_hash[:options][:provisioning_profile] = "/Path/To/Somewhere/That/Does/Not/Exist/nope.mobileprovision"
# 		create_mock_config_file non_existing_profile_hash, "missing"

# 		missing_required_tasks_workspace_hash = deep_dup_config valid_create_ipa_config
# 		missing_required_tasks_workspace_hash[:run_tasks][:xcode_build] = false
# 		create_mock_config_file missing_required_tasks_workspace_hash, "needs_task"

# 	end

# 	after(:all) do
# 		delete_all_mock_config_files
# 		clear_reports
# 	end

# 	describe "create_ipa" do

# 		before(:each) { Singleton.__init__(BuildKit::Runner) }

# 		let(:runner) { BuildKit::Runner.instance }
# 		let!(:mock_valid_config_file) { mock_config_file_path "valid" }
# 		let!(:mock_missing_required_option_config_file) { mock_config_file_path "nil_option" }
# 		let!(:mock_non_existent_file_config_file) { mock_config_file_path "missing" }
# 		let!(:mock_missing_required_tasks_config_file) { mock_config_file_path "needs_task" }
		
# 		describe "required config, files and tasks" do
# 			it "checks xcode_build has completed" do
# 				runner.configure(config: mock_valid_config_file)
# 				BuildKit.should_receive(:assert_tasks_completed).with([:xcode_build])
# 				runner.run_tasks
# 			end
# 			it "checks assert_required_config" do
# 				BuildKit.should_receive(:assert_required_config).ordered.with([:app_name, :workspace, :sdk, :build_configuration, :build_dir, :scheme])
# 				BuildKit.should_receive(:assert_required_config).ordered.with([:code_sign, :provisioning_profile])
# 				runner.configure(config: mock_valid_config_file)
# 				runner.run_tasks
# 			end
# 			it "checks assert_files_exist" do
# 				runner.configure(config: mock_valid_config_file)
# 				BuildKit.should_receive(:assert_files_exist).ordered.with([valid_config[:options][:workspace], valid_config[:options][:build_dir]])
# 				BuildKit.should_receive(:assert_files_exist).ordered.with([valid_config[:options][:provisioning_profile]])
# 				runner.run_tasks
# 			end
# 			context "empty required parameters" do
# 				before { runner.configure(config: mock_missing_required_option_config_file) }
# 				specify { expect { runner.run_tasks }.to raise_error }
# 			end
# 			context "non existent file (mocked with provisioning profile)" do
# 				before { runner.configure(config: mock_non_existent_file_config_file) }
# 				specify { expect { runner.run_tasks }.to raise_error }
# 			end
# 			context "xcode_build not run" do
# 				before { runner.configure(config: mock_missing_required_tasks_config_file) }
# 				specify { expect { runner.run_tasks }.to raise_error }
# 			end
# 		end

# 		describe "ipa creation" do
# 			let!(:existing_ipa_file_count) { Dir["#{valid_config[:options][:build_dir]}*.ipa"].length }
# 			let(:ipa_count_lambda) { -> { Dir["#{valid_config[:options][:build_dir]}*.ipa"].length } }
# 		  before do
# 				runner.configure(config: mock_valid_config_file)
# 				runner.run_tasks
# 		  end
# 		  specify { ipa_count_lambda.call.should == existing_ipa_file_count + 1 }		  
# 		  specify { runner.store[:artefact_created].should_not be_nil }		
# 		end

# 		describe "task completion" do
# 		  before do
# 				runner.configure(config: mock_valid_config_file)
# 				runner.run_tasks
# 			end
# 			specify { runner.tasks[:completed].include?(:create_ipa).should be_true }
# 			specify { runner.outputs[:create_ipa].should_not be_nil }
# 		end

# 	end

# end