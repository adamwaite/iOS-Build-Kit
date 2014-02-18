require_relative 'spec_helper'

describe "xcode_build task" do
  
	describe "invalid config handling" do
	  
		context "missing configuration" do

			context "app_name" do
				pending "raise exception"
			end

			context "workspace" do
				pending "raise exception"
			end

			context "build_configuration" do
				pending "raise exception"
			end

			context "build_dir" do
				pending "raise exception"
			end

			context "scheme" do
				pending "raise exception"
			end

		end
		
		context "non-existent files" do

			context "workspace" do
				pending "raise exception"	
			end

			context "build_dir" do
				pending "raise exception"
			end

		end

	end

	describe "successful build" do
	  pending "runner.store[:xcode_build_succeeded].should be_true"
	end

	describe "failing build" do
	  pending "runner.store[:xcode_build_succeeded].should_not be_true <- need to create a target that fails to build, spelling mistake or something"
	end

	describe "task completion" do
		pending "runner.tasks[:completed].include?(:xcode_build).should be_true"
		pending "runner.outputs[:xcode_build].should_not be_nil"
	end

end