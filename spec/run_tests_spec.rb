require_relative 'spec_helper'

describe "run_tests task" do
  
	describe "invalid config handling" do
	  
		context "missing configuration" do
			
			context "workspace" do
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

		end

	end

	describe "passing tests" do
	  pending "runner.store[:tests_passed].should be_true"
	end

	describe "failing tests" do
	  pending "runner.store[:tests_passed].should_not be_true <- need to create a failing test target. compare YES to NO or something"
	end

	describe "task completion" do
		pending "runner.tasks[:completed].include?(:run_tests).should be_true"
		pending "runner.outputs[:run_tests].should_not be_nil"
	end

end