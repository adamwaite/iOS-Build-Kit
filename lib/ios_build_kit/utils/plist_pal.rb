module BuildKit

  Dir["./*.rb"].each {|file| require file }

  module Utilities

    module PlistPal

      def self.read_value_in_plist plist, key
        %x[/usr/libexec/PlistBuddy -c "Print #{key}" \"#{plist}\"]
      end

      def self.write_value_in_plist plist, key, value
        plist_buddy_command = "\"Set :#{key} #{value}\" \"#{plist}\""
        system "/usr/libexec/PlistBuddy -c #{plist_buddy_command}"
      end

      def self.brute_replace_in_plist plist, value, new_value
    	  original = File.read plist
      	updated = original.gsub value, new_value
      	File.open(plist, "w") { |file| file.write updated }
    	end

    end

  end

end