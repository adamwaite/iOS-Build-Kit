module BuildKit
  
  module Tasks

    def self.run_tests runner, task_opts
      task = RunTestsTask.new({ runner: runner, opts: task_opts })
      task.run!
    end

    private

    class RunTestsTask < BuildKitTask

      attr_reader :output

      def run!
        run_command!
        complete_task!
      end

      private

      def assert_requirements
        BuildKit::Utilities::Assertions.assert_required_config [:workspace, :scheme], @runner
        BuildKit::Utilities::Assertions.assert_files_exist [@config.workspace]
      end

      def build_command
        workspace_arg = "-workspace \"#{@config.workspace}\""
        scheme_arg = "-scheme \"#{@config.scheme}\""
        "xctool #{workspace_arg} #{scheme_arg} -sdk iphonesimulator ONLY_ACTIVE_ARCH=NO test -freshSimulator -parallelize"
      end

      def run_command!
        command = build_command
        @output = %x[#{command}]
        puts @output if @task_options[:log]
      end

      def tests_passed?
        @output.include? "TEST SUCCEEDED"
      end

      def complete_task!
        runner.store[:tests_passed] = tests_passed?
        message = (tests_passed?) ? "run_tests completed successfully, tests all passed" : "run_tests completed successfully, tests failed"
        @runner.task_completed! :run_tests, message, @output 
      end

    end

  end
  
end