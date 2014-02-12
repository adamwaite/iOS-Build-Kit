# require_relative 'spec_helper'

# describe "BuildKit" do

# 	before(:all) do

# 		valid_decorate_icon_config = valid_config
# 		valid_decorate_icon_config[:run_tasks][:decorate_icon] = true
# 		create_mock_config_file valid_decorate_icon_config, "valid"

# 		missing_options_hash = deep_dup_config valid_decorate_icon_config
# 		missing_options_hash[:options][:icon_dir] = nil
# 		create_mock_config_file missing_options_hash, "nil_option"

# 		non_existing_icon_folder_hash = deep_dup_config valid_decorate_icon_config
# 		non_existing_icon_folder_hash[:options][:icon_dir] = "/Path/To/Somewhere/That/Does/Not/Exist/"
# 		create_mock_config_file non_existing_icon_folder_hash, "missing"
	
# 	end

# 	after(:all) do
# 		delete_all_mock_config_files
# 		clear_reports
# 	end

# 	describe "decorate_icon" do
	
# 		before(:each) { Singleton.__init__(BuildKit::Runner) }
		
# 		let(:runner) { BuildKit::Runner.instance }
# 		let!(:mock_valid_config_file) { mock_config_file_path "valid" }
# 		let!(:mock_missing_required_option_config_file) { mock_config_file_path "nil_option" }
# 		let!(:mock_non_existent_file_config_file) { mock_config_file_path "missing" }

# 		describe "required config, files and tasks" do
# 			it "checks assert_required_config" do
# 				BuildKit.should_receive(:assert_required_config).ordered.with([:info_plist, :icon_dir])
# 				runner.configure(config: mock_valid_config_file)
# 				runner.run_tasks
# 			end
# 			it "checks assert_files_exist" do
# 				runner.configure(config: mock_valid_config_file)
# 				BuildKit.should_receive(:assert_files_exist).ordered.with([valid_config[:options][:info_plist], valid_config[:options][:icon_dir]])
# 				runner.run_tasks
# 			end
# 			context "empty required parameters" do
# 				before { runner.configure(config: mock_missing_required_option_config_file) }
# 				specify { expect { runner.run_tasks }.to raise_error }
# 			end
# 			context "non existent file (mocked with icon_dir)" do
# 				before { runner.configure(config: mock_non_existent_file_config_file) }
# 				specify { expect { runner.run_tasks }.to raise_error }
# 			end
# 		end

		

# 	end

# end