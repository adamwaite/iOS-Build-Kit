require_relative 'spec_helper'

describe "report generation" do

  let(:run_task) { :increment_version.to_s }
  let(:report_path) { vc[:preferences][:reports] }
  let(:report_count) { Dir["#{report_path}/*.json"].count }

	context "reports on" do
		let(:runner) { mock_runner vc.enable_increment_version! }
    before { runner.run_tasks! }
    specify { report_count.should == 1 }
	end

	context "reports off" do
		let(:runner) { mock_runner vc.enable_increment_version!.modify_preference! :reports, nil }
    before { runner.run_tasks! }
    specify { report_count.should == 0 }
	end

  context "JSON" do
    let(:runner) { mock_runner vc.enable_increment_version! }
    let(:report) { Dir["#{report_path}/*.json"].first }
    let(:report_json_string) { File.read(Dir["#{report_path}/*.json"].first) }
    let(:report_content_hash) { JSON.parse(report_json_string) }
    before { runner.run_tasks! }
    specify { report_json_string.should be_kind_of String }
    specify { report_content_hash.should be_kind_of Hash }
    specify { report_content_hash[:time.to_s].should_not be_nil }
    specify { report_content_hash[:config.to_s].should_not be_nil }
    specify { report_content_hash[:preferences.to_s].should_not be_nil }
    specify { report_content_hash[:runtime_store.to_s].should_not be_nil }
    specify { report_content_hash[:outputs.to_s].should_not be_nil }
    specify { report_content_hash[:outputs.to_s][run_task].should_not be_nil }
  end

end