module BuildKit

  module Utilities

  	module Console

			def self.header_msg h
			  puts "\n\n" + h + "\n" + ("-" * h.length) + "\n"
			end

			def self.warning_msg m
			  puts "\nNotice:" + m + "\n"
			end

			def self.success_msg m
			  puts "\n#{m}\n"
			end

			def self.terminate_with_err err
	      puts "\n💣  Terminating with error: #{err}\n\n"
	      exit
	    end

		end

	end

end