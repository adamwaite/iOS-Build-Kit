# require_relative 'spec_helper'

# describe "BuildKit" do

# 	before(:all) do
# 		create_mock_config_file valid_config, "valid"
# 	end

# 	after(:all) do
# 		delete_all_mock_config_files
# 		clear_reports
# 	end

# 	describe "Runner instance" do

# 		before(:each) { Singleton.__init__(BuildKit::Runner) }
		
# 		let(:runner) { BuildKit::Runner.instance }
# 		let!(:mock_config_file) { mock_config_file_path "valid" }

# 		describe "type checking" do
# 		  specify { runner.should_not be_nil  }
# 			specify { runner.should be_kind_of Singleton }
# 			specify { runner.should be_kind_of BuildKit::Runner }
# 		end

# 		describe "config file assertion" do
# 		  specify { expect { runner.configure(config: nil) }.to raise_error }
# 			it "calls assert_file_exists" do
# 				BuildKit.should_receive(:assert_files_exist).with([mock_config_file])
# 				runner.configure(config: mock_config_file)
# 			end
# 		end

# 		describe "configuration" do
# 			before { runner.configure(config: mock_config_file) }		
# 			describe "tasks" do
# 				specify { runner.tasks.should be_kind_of Hash }
# 				specify { runner.tasks[:raw].should be_kind_of Hash }
# 				specify { runner.tasks[:run].should be_kind_of Array }
# 				specify { runner.tasks[:skip].should be_kind_of Array }
# 				specify { runner.tasks[:raw].should == valid_config[:run_tasks] }
# 				specify { runner.tasks[:run].should == valid_config[:run_tasks].select { |k, v| v == true }.map { |k, v| k } } 
# 				specify { runner.tasks[:skip].should == valid_config[:run_tasks].select { |k, v| v == false }.map { |k, v| k } }
# 			end
# 			describe "config" do
# 				specify { runner.config.should be_kind_of Hash }
# 				specify { runner.config.should == valid_config[:options] }
# 				specify { runner.config[:app_name].should == valid_config[:options][:app_name] }
# 			end
# 		end

# 		describe "runtime store" do
# 		  specify { runner.store.should be_kind_of Hash }
# 		end

# 	end

# end