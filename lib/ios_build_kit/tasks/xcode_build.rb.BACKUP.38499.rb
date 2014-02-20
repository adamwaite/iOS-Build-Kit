module BuildKit
  
  module Tasks

    require "fileutils"
    
    def self.xcode_build runner, task_opts
      task = XcodeBuildTask.new({ runner: runner, opts: task_opts })
      task.run!
    end

    private

    class XcodeBuildTask < BuildKitTask

      attr_reader :output

      def run!
        run_command! "clean" if @task_options[:clean]
        run_command! "build"
        create_build_directory unless File.exists?(@config.absolute_build_dir)
        complete_task!
      end

      private

      def assert_requirements
        BuildKit::Utilities::Assertions.assert_required_config [:app_name, :workspace, :sdk, :build_configuration, :build_dir, :scheme], @runner
      end

      def create_build_directory
        FileUtils.mkdir_p(@config.absolute_build_dir)
      end

      def build_command cmd
        workspace_arg = "-workspace \"#{@config.workspace}\""
        sdk_arg = "-sdk \"#{@config.sdk}\""
        scheme_arg = "-scheme \"#{@config.scheme}\""   
        configuration_arg = "-configuration \"#{@config.build_configuration}\""
        build_dir_arg = "CONFIGURATION_BUILD_DIR=\"#{@config.absolute_build_dir}\""
        "xcodebuild #{workspace_arg} #{sdk_arg} #{scheme_arg} #{configuration_arg} #{build_dir_arg} #{cmd} | xcpretty -c; echo EXIT CODE: ${PIPESTATUS}"
      end

      def run_command! cmd
        command = build_command cmd
        cmd_output = %x[#{command}]
        @output = cmd_output if is_build? cmd
        puts cmd_output if @task_options[:log]
      end

      def is_build? cmd
        cmd == "build"
      end

      def build_succeeded?
        @output.include? "EXIT CODE: 0"
      end

      def complete_task!
        @runner.store[:xcode_build_succeeded] = build_succeeded?
        message = (build_succeeded?) ? "xcode_build completed, project built successfully" : "xcode_build completed, but the project failed to build"
        @runner.task_completed! :xcode_build, message, @output 
      end

    end

  end
  
end