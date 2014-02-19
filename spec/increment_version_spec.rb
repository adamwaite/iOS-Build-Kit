require_relative 'spec_helper'

describe "xcode_build task" do
  
	describe "invalid config handling" do
	  
		context "missing configuration" do

			context "info_plist" do
				pending "raise exception"
			end

		end
		
		context "non-existent files" do

			context "info_plist" do
				pending "raise exception"	
			end

		end

	end

	describe "plist reading" do		
		pending "it reads major, minor, build version"
		pending "it reads revision version"
	end

	describe "existing version" do
	  pending "it stores the existing version"
	end

	describe "new version" do
	  pending "it stores the existing version"
	end

	describe "writing the new version to the plist" do
		pending "it increments the existing version"
		pending "it stores the new version"
	end

	describe "task completion" do
		pending "runner.tasks[:completed].include?(:increment_version).should be_true"
		pending "runner.outputs[:increment_version].should_not be_nil"
	end

end