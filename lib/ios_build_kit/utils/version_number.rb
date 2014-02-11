module BuildKit
    
  module Utilities

    module VersionNumber

      def self.plist_version_number plist
        version = BuildKit::Utilities::PlistPal.read_value_in_plist plist, "CFBundleShortVersionString"
        build = BuildKit::Utilities::PlistPal.read_value_in_plist(plist, "CFBundleVersion").to_i 
        hash_from_version_and_build version, build
      end

      def self.hash_from_version_and_build version, build
        hash = {}
        split_version = version.split(".").map { |s| s.to_i }
        hash[:major] = split_version[0].nil? ? 0 : split_version[0]
        hash[:minor] = split_version[1].nil? ? 0 : split_version[1]
        hash[:revision] = split_version[2].nil? ? 0 : split_version[2]
        hash[:major_minor_revision] = [hash[:major], hash[:minor], hash[:revision]].join(".")
        hash[:build] = build
        hash[:full] = [hash[:major_minor_revision], hash[:build]].join(".")
        hash
      end

    end

  end

end