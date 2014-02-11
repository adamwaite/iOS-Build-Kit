module BuildKit
  
  require 'yaml' 

  module Runner

    class TaskRunner
          
      attr_reader :config, :tasks, :outputs

      attr_accessor :store
      
      def initialize(attributes = {})
        passed_opts = hash_from_yaml attributes[:config]
        @config = TaskRunnerConfig.new(passed_opts[:options]).freeze
        prepare_task_queue! passed_opts[:run_tasks]
        @store = {}
        @outputs = {}
        run_tasks!
      end

      def has_completed_task? task
        @tasks[:completed].include? task
      end

      def task_completed! task, success_message, output
        @tasks[:completed] << task
        BuildKit::Utilities::Console.success_msg success_message
        @outputs[task] = output
      end

      private

      def hash_from_yaml file
        YAML.load_file(file)
      end

      def prepare_task_queue! tasks
        @tasks = { raw: {}, run: [], skip: [], completed: [], running: nil }
        @tasks[:raw] = tasks.freeze
        @tasks[:run] = tasks.select { |k, v| v == true }.map { |k, v| k }.freeze
        @tasks[:skip] = tasks.select { |k, v| v == false }.map { |k, v| k }.freeze
      end
      
      def run_tasks!
        @tasks[:raw].each do |task_name, run|
          if run
            @tasks[:running] = task_name
            BuildKit::Utilities::Console.header_msg "Running Task: #{task_name}"
            BuildKit::Tasks.send task_name, self
          else
            BuildKit::Utilities::Console.header_msg "Skipping Task: #{task_name}"
          end
        end
        all_tasks_completed
      end
      
      def all_tasks_completed
        # BuildKit.create_report self
        BuildKit::Utilities::Console.success_msg "\n😃  BuildKit Run Completed! Ran #{@tasks[:completed].count} tasks successfully!\n\n"
      end
      
    end

  end
      
end