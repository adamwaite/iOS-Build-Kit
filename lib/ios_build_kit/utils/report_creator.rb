module BuildKit
  
  require 'json'

  module Utilities

	  module PlistPal

		  def self.create_report runner
		    to_write = { time: Time.now.to_s, config: runner.config, outputs: {} }
		    runner.tasks[:run].each { |task| to_write[:outputs][task] = runner.outputs[task] }
		    File.open("reports/report-#{Time.now.to_i}.json", 'w') { |f| f.write to_write.to_json }
		  end

		end

	end	

end