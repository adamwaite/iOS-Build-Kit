module BuildKit

  Dir["./*.rb"].each {|file| require file }

  module Utilities

    module PlistPal

      def self.read_value_in_plist plist, key
        %x[/usr/libexec/PlistBuddy -c "Print #{key}" \"#{plist}\"]
      end

      def self.read_array_value_in_plist plist, key
        array_value = []
        index = 0
        loop do
          value = %x[/usr/libexec/PlistBuddy -c "Print #{key}:#{index}" \"#{plist}\" 2>/dev/null]
          break if !$?.success? || value.nil?
          array_value.push value.strip
          index += 1
        end
        return array_value
      end

      def self.write_value_in_plist plist, key, value
        plist_buddy_command = "\"Set :#{key} #{value}\" \"#{plist}\""
        system "/usr/libexec/PlistBuddy -c #{plist_buddy_command}"
      end

      def self.write_array_value_in_plist plist, key, array_value
        system "/usr/libexec/PlistBuddy -c \"Delete #{key}\" \"#{plist}\""
        system "/usr/libexec/PlistBuddy -c \"Add #{key} array\" \"#{plist}\""
        array_value.each_with_index do |value, index|
          system "/usr/libexec/PlistBuddy -c \"Add #{key}:#{index} string #{value}\" \"#{plist}\""
        end
      end

      def self.brute_replace_in_plist plist, value, new_value
        original = File.read plist
        updated = original.gsub value, new_value
        File.open(plist, "w") { |file| file.write updated }
      end

    end

  end

end