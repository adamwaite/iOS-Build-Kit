module BuildKit
  
  module Tasks

    def self.xcode_build runner, task_opts
      task = XcodeBuildTask.new({ runner: runner, opts: task_opts })
      task.run!
    end

    private

    class XcodeBuildTask < BuildKitTask

      attr_reader :output

      def run!
        run_command!
        complete_task!
      end

      private

      def assert_requirements
        BuildKit::Utilities::Assertions.assert_required_config [:app_name, :workspace, :sdk, :build_configuration, :build_dir, :scheme], @runner
        BuildKit::Utilities::Assertions.assert_files_exist [@config.workspace, @config.build_dir]
      end

      def build_command
        workspace_arg = "-workspace \"#{@config.workspace}\""
        sdk_arg = "-sdk \"#{@config.sdk}\""
        scheme_arg = "-scheme \"#{@config.scheme}\""   
        configuration_arg = "-configuration \"#{@config.build_configuration}\""
        build_dir_arg = "CONFIGURATION_BUILD_DIR=\"#{@config.build_dir}\""
        "xcodebuild #{workspace_arg} #{sdk_arg} #{scheme_arg} #{configuration_arg} #{build_dir_arg} build | xcpretty -c"
      end

      def run_command!
        command = build_command
        @output = %x[#{command}]
        puts @output if @task_options[:log]
      end

      def build_succeeded?
        @output.include? "BUILD SUCCEEDED"
      end

      def complete_task!
        @runner.store[:xcode_build_succeeded] = build_succeeded?
        message = (build_succeeded?) ? "xcode_build completed, project built successfully" : "xcode_build completed, but the project failed to build"
        @runner.task_completed! :xcode_build, message, @output 
      end

    end

  end
  
end