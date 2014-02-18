module BuildKit
	
  module Utilities

    module Assertions

      def self.assert_files_exist files
      	files.each do |file| 
          BuildKit::Utilities::Console.terminate_with_err "Missing File: #{file} does not exist" unless File.exists? file 
        end
      end

    	def self.assert_required_config req_keys, runner
        req_keys.each do |k| 
          BuildKit::Utilities::Console.terminate_with_err "Missing Configuration: #{k} is required to run #{runner.tasks[:running]}" if runner.config[k].nil?
        end
      end

      def self.assert_tasks_completed req_tasks, runner
        req_tasks.each do |t| 
          BuildKit::Utilities::Console.terminate_with_err "Task Required: #{t.to_s} should be completed to run #{runner.tasks[:running]}" unless runner.has_completed_task? t
        end
      end

      def self.assert_symbol_hash_keys hash
        #TODO
      end

    end

  end

end