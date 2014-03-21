module BuildKit

  module Utilities

  	module Console

  		require 'paint'
  		require 'paint/pa'

			def self.header_msg h
			  pa "#{spaces}#{h}#{end_msg}", :black, :bold, :underline
			end

			def self.info_msg m
			  pa "#{begin_msg}#{m}#{end_msg}", :blue
			end

			def self.warning_msg m
			  pa "#{begin_msg}#{m}#{end_msg}", :yellow
			end

			def self.success_msg m
			  pa "#{begin_msg}#{m}#{end_msg}", :green
			end

			def self.terminate_with_err err
	      pa "#{begin_msg}💣  Terminating with error: #{err}  💣#{end_msg}", :red
	      exit
	    end

	    private

	    def self.begin_msg
	    	"\n#{spaces} BK - "
	    end

	    def self.end_msg
	    	"\n"
	    end

	    def self.spaces
	    	" " * 3
	    end

		end

	end

end