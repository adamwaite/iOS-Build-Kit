# require_relative 'spec_helper'

# describe "Runner" do

# 	describe "Runner instance" do
# 		context "with a valid configuration file" do
# 			let(:runner) { mock_runner vc }
# 			specify { runner.should_not be_nil  }
# 			specify { runner.should be_kind_of BuildKit::Runner::TaskRunner }
# 		end

# 		context "no configuration file" do
# 			specify { expect { BuildKit::Runner::TaskRunner.new }.to raise_error }
# 		end	

# 		context "invalid configuration file" do
# 			specify { expect { BuildKit::Runner::TaskRunner.new({ config_file: "/does/not/exist/" }) }.to raise_error }
# 		end
# 	end

# end