module BuildKit
      
  module Tasks

    def self.increment_version runner
      task = IncrementVersionTask.new(runner: runner)
      task.run!
    end

    private

    class IncrementVersionTask < BuildKitTask

      attr_reader :existing_version_number, :new_version_number

      def run!
        read_existing_version!
        calculate_new_version!
        write_new_version!
        complete_task!
      end

      private

      def assert_requirements
        BuildKit::Utilities::Assertions.assert_files_exist [@config.info_plist]
      end

      def read_existing_version!
        @existing_version_number = BuildKit::Utilities::VersionNumber.plist_version_number @config.info_plist
        @runner.store[:existing_version_number] = @existing_version_number
      end

      def calculate_new_version!
        incremented_build_number = @existing_version_number[:build] + 1
        @new_version_number = BuildKit::Utilities::VersionNumber.hash_from_version_and_build @existing_version_number[:major_minor_revision], incremented_build_number
        @runner.store[:new_version_number] = @new_version_number
      end

      def write_new_version!
        BuildKit::Utilities::PlistPal.write_value_in_plist(@config.info_plist, "CFBundleShortVersionString", @new_version_number[:major_minor_revision] )
        BuildKit::Utilities::PlistPal.write_value_in_plist(@config.info_plist, "CFBundleVersion", @new_version_number[:build] )
      end

      def complete_task!
        output = "incremented version number from #{@existing_version_number[:full]} to #{@new_version_number[:full]}"
        message = output + " and written to plist successfully"
        @runner.task_completed! :increment_version, message, output
      end

    end

  end
  
end