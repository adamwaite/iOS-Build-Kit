module BuildKit
  
  require 'yaml'

  module Runner

    class TaskRunner
          
      attr_reader :config, :preferences, :tasks, :outputs

      attr_accessor :store
      
      def initialize(attributes = {})
        passed = hash_from_yaml attributes[:config_file]
        @config = TaskRunnerConfig.new(passed[:configuration]).freeze
        @preferences = TaskRunnerConfig.new (passed[:preferences]).freeze
        prepare_task_queue! passed[:tasks]
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
        @tasks[:run] = tasks.select { |k, v| v[:run] == true }.map do |k, v| 
          t = Hash.new
          t[k] = { run: v[:run], options: v[:options] }
          t
        end.freeze
        @tasks[:skip] = tasks.select { |k, v| v[:run] == false }.map do |k, v| 
          t = Hash.new
          t[k] = { run: v[:run], options: v[:options] }
          t
        end.freeze      
        @tasks[:run].freeze
        @tasks[:skip].freeze
      end
      
      def run_tasks!
        @tasks[:raw].each do |task_name, task_opts|
          if task_opts[:run]
            @tasks[:running] = task_name
            BuildKit::Utilities::Console.header_msg "Running Task: #{task_name}"
            BuildKit::Tasks.send task_name, self, task_opts[:options]
          else
            BuildKit::Utilities::Console.header_msg "Skipping Task: #{task_name}"
          end
        end
        all_tasks_completed
      end
      
      def all_tasks_completed
        unless @preferences.reports.nil?
          if File.exists? @preferences.reports
            build_report = BuildKit::Utilities::Reporter::create_report self
            BuildKit::Utilities::Console.success_msg "BuildKit run report created at: #{build_report}"
          else
            puts "Warning: Report not created. Invalid directory specified: #{@preferences.reports}"
          end
        end
        BuildKit::Utilities::Console.success_msg "\n😃  BuildKit Run Completed! Ran #{@tasks[:completed].count} tasks successfully!\n\n"
      end

    end

  end
      
end