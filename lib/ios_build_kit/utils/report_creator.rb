module BuildKit
  
  require 'json'

  module Utilities

	  module Reporter

		  def self.create_report runner
		    to_write = { time: Time.now.to_s, config: runner.config.to_h, preferences: runner.preferences.to_h, runtime_store: runner.store, outputs: {} }
		    runner.tasks[:run].each { |task| to_write[:outputs][task.keys.first] = runner.outputs[task.keys.first] }
		    file_name = File.join(runner.preferences.reports, "report-#{Time.now.to_i}.json")
		    File.open(file_name, 'w') { |f| f.write to_write.to_json }
		    puts "DEBUG"
		    puts runner.preferences.reports
		    puts file_name
		  	file_name
		  end

		end

	end	

end