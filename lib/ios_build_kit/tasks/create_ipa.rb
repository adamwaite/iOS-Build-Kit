module BuildKit
  
  module Tasks

    def self.create_ipa runner, task_opts
      task = CreateIPATask.new({ runner: runner, opts: task_opts })
      task.run!
    end
      
    private

  class CreateIPATask < BuildKitTask

      attr_accessor :artefact_filename

      def initialize(attributes = {})
        super
        warn_about_missing_plist_config if @config.info_plist.nil?
      end

      def run!
        build_artefact_filename!
        run_command!
        complete_task!
      end

      private

      def assert_requirements
        BuildKit::Utilities::Assertions.assert_tasks_completed [:xcode_build], @runner
        BuildKit::Utilities::Assertions.assert_required_config [:code_sign, :provisioning_profile], @runner
        BuildKit::Utilities::Assertions.assert_files_exist [@config.provisioning_profile]
      end

      def warn_about_missing_plist_config
        BuildKit.warning_msg "Provide the :info_plist option in the config file to include the version number in the ipa file name" 
      end

      def build_artefact_filename!
        name = @config.app_name.dup
        if (!@config.info_plist.nil? and File.exists? @config.info_plist)
          name << "-"
          if @runner.has_completed_task? :increment_version
            name << @runner.store[:new_version_number][:full]
          else
            name << BuildKit::Utilities::VersionNumber.plist_version_number[:full]
          end
        end
        name << "-"
        name << Time.now.to_i.to_s
        name << ".ipa"
        @artefact_filename = name
      end

      def artefact_full_path
        build_artefact_filename! if @artefact_filename.nil?
        @config.build_dir + @artefact_filename
      end

      def existing_ipa_count
        Dir["#{@build_dir}*.ipa"].length
      end

      def build_command
        workspace_arg = "-workspace \"#{@config.workspace}\""
        sdk_arg = "-sdk #{@config.sdk}"
        build_file_arg = "-v \"#{@config.build_dir}#{@config.app_name}.app\"" 
        output_file_arg = "-o \"#{artefact_full_path}\"" 
        code_sign_arg = "--sign #{@config.code_sign}"
        provisioning_arg = "--embed \"#{@config.provisioning_profile}\""
        "xcrun #{sdk_arg} PackageApplication #{build_file_arg} #{output_file_arg} #{provisioning_arg}"
      end

      def run_command!
        command = build_command
        @output = %x[#{command}]
        puts @output if @task_options[:log]
      end

      def ipa_created_successfully?
        File.exists? artefact_full_path
      end

      def complete_task!
        runner.store[:artefact_created] = artefact_full_path if ipa_created_successfully?
        message = (ipa_created_successfully?) ? "create_ipa completed, ipa at: #{artefact_full_path}" : "create_ipa task completed but the ipa was not created"
        runner.task_completed! :create_ipa, message, @output 
      end

    end
      
  end
  
end