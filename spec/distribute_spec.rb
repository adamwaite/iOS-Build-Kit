require_relative 'spec_helper'

describe "distribute task" do
  
  # describe "invalid config handling" do
  #   context "missing previous tasks" do
  #     context "increment_version" do
  #       let(:runner) { mock_runner vc.enable_xcode_build!.enable_create_ipa!.enable_distribute! }
  #       specify { expect { runner.run_tasks! }.to raise_error }
  #     end
  #     context "create_ipa" do
  #       let(:runner) { mock_runner vc.enable_increment_version!.enable_xcode_build!.enable_distribute! }
  #       specify { expect { runner.run_tasks! }.to raise_error }
  #     end
  #   end
  #   context "no platform" do
  #     let(:runner) { mock_runner vc.modify_task_option!(:distribute, :platform, "lolflight").enable_increment_version!.enable_xcode_build!.enable_create_ipa!.enable_distribute! }
  #     specify { expect { runner.run_tasks! }.to raise_error }
  #   end
  # end

  # describe "HockeyApp" do
  #   let(:runner) { mock_runner vc.enable_increment_version!.enable_xcode_build!.enable_create_ipa!.enable_distribute! }
  #   before { runner.run_tasks! }
  #   specify { runner.store[:distribute_succeeded].should be_true }
  # end

  # describe "task completion" do
  #   let(:runner) { mock_runner vc.enable_increment_version!.enable_xcode_build!.enable_create_ipa!.enable_distribute! }
  #   before { runner.run_tasks! }
  #   specify { runner.tasks[:completed].include?(:distribute).should be_true }
  #   specify { runner.outputs[:distribute].should_not be_nil }
  # end

end