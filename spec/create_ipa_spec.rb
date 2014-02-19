require_relative 'spec_helper'

describe "decorate_icon task" do
  
	describe "invalid config handling" do
	  
		context "missing previous tasks" do
			
			context "xcode_build" do
				pending "raise exception"
			end

		end

	end

	describe "ipa creation" do		
		pending "the build dir has a new ipa file"
	end

	describe "task completion" do
		pending "runner.tasks[:completed].include?(:create_ipa).should be_true"
		pending "runner.outputs[:create_ipa].should_not be_nil"
	end

end