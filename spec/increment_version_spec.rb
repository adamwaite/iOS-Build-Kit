require_relative 'spec_helper'

describe "BuildKit" do

	before(:all) do

		valid_increment_version_config = valid_config
		valid_increment_version_config[:run_tasks][:increment_version] = true
		create_mock_config_file valid_increment_version_config, "valid"

		missing_plist_option_hash = deep_dup_config valid_increment_version_config
		missing_plist_option_hash[:options][:info_plist] = nil
		create_mock_config_file missing_plist_option_hash, "nil_option"

		non_existing_plist_hash = deep_dup_config valid_increment_version_config
		non_existing_plist_hash[:options][:info_plist] = "/Path/To/Somewhere/That/Does/Not/Exist/app-info.plist"
		create_mock_config_file non_existing_plist_hash, "missing"

	end

	after(:all) do
		delete_all_mock_config_files
		clear_reports
	end

	describe "increment_version" do

		before(:each) { Singleton.__init__(BuildKit::Runner) }

		let(:runner) { BuildKit::Runner.instance }
		let!(:mock_valid_config_file) { mock_config_file_path "valid" }
		let!(:mock_missing_required_option_config_file) { mock_config_file_path "nil_option" }
		let!(:mock_non_existent_file_config_file) { mock_config_file_path "missing" }

		describe "required config and files" do
			it "checks assert_required_config" do
				BuildKit.should_receive(:assert_required_config).with([:info_plist])
				runner.configure(config: mock_valid_config_file)
				runner.run_tasks
			end
			it "checks assert_files_exist" do
				runner.configure(config: mock_valid_config_file)
				BuildKit.should_receive(:assert_files_exist).with([valid_config[:options][:info_plist]])
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

		describe "plist reading" do
			let(:build_number) { BuildKit.read_value_in_plist(valid_config[:options][:info_plist], "CFBundleShortVersionString") }
			specify { build_number.should_not be_nil }
			specify { build_number.should be_kind_of String }
		end

		describe "existing version" do
			before do
				runner.configure(config: mock_valid_config_file)
				runner.run_tasks
			end
		  specify { runner.store[:existing_version_number].should be_kind_of Hash }
		  specify { runner.store[:existing_version_number][:major].should be_kind_of Integer }
		  specify { runner.store[:existing_version_number][:minor].should be_kind_of Integer }
		  specify { runner.store[:existing_version_number][:revision].should be_kind_of Integer }
		  specify { runner.store[:existing_version_number][:build].should be_kind_of Integer }
		  specify { runner.store[:existing_version_number][:full].should be_kind_of String }
		end

		describe "new version" do
			before do
				runner.configure(config: mock_valid_config_file)
				runner.run_tasks
			end
			let(:existing_build_number) { runner.store[:existing_version_number][:build] }
		  specify { runner.store[:new_version_number].should be_kind_of Hash }
		  specify { runner.store[:new_version_number][:major].should be_kind_of Integer }
		  specify { runner.store[:new_version_number][:minor].should be_kind_of Integer }
		  specify { runner.store[:new_version_number][:revision].should be_kind_of Integer }
		  specify { runner.store[:new_version_number][:build].should be_kind_of Integer }
		  specify { runner.store[:new_version_number][:build].should == existing_build_number.to_i + 1 }
		  specify { runner.store[:new_version_number][:full].should be_kind_of String }
		end

		describe "writing the new version to the plist" do
			let!(:existing) { BuildKit.read_value_in_plist(valid_config[:options][:info_plist], "CFBundleVersion").to_i }
			let!(:plist_path) { valid_config[:options][:info_plist] }
			before do
				runner.configure(config: mock_valid_config_file)
				runner.run_tasks
			end
			specify { existing.should be_kind_of Integer }
			specify { BuildKit.read_value_in_plist(plist_path, "CFBundleVersion").to_i.should == (existing + 1).to_i }
		end

		describe "task completion" do
		  before do
				runner.configure(config: mock_valid_config_file)
				runner.run_tasks
			end
			specify { runner.tasks[:completed].include?(:increment_version).should be_true }
			specify { runner.outputs[:increment_version].should_not be_nil }
		end

	end

end