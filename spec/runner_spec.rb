require_relative 'spec_helper'

describe "Runner" do

	describe "Runner instance" do

		context "no configuration file" do
			specify { expect { BuildKit::Runner::TaskRunner.new }.to raise_error }
		end	

		context "invalid configuration file" do
			specify { expect { BuildKit::Runner::TaskRunner.new({ config_file: "/does/not/exist/" }) }.to raise_error }
		end

	end

end