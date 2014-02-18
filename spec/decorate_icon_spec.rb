require_relative 'spec_helper'

describe "decorate_icon task" do
  
	describe "invalid config handling" do
	  
		context "missing configuration" do

			context "icon_dir" do
				pending "raise exception"	
			end

		end
		
		context "non-existent files" do

			context "icon_dir" do
				pending "raise exception"	
			end

		end

	end

	describe "new icons" do		
		pending "the icon dir has as many new files of type png as there was beforehand"
	end

	describe "task completion" do
		pending "runner.tasks[:completed].include?(:decorate_icon).should be_true"
		pending "runner.outputs[:decorate_icon].should_not be_nil"
	end

end