# module BuildKit
  
#   module Tasks
    
#     def self.distribute runner, task_opts
#       task = DistributeTask.new({ runner: runner, opts: task_opts })
#       task.run!
#     end

#     private

#     class DistributeTask < BuildKitTask

#       attr_reader :output

#       def run!
#         case @task_options[:platform]
#           when "hockeyapp"
#             distribute_with_hockeyapp
#           when "testflight"
#             distribute_with_testflight
#           else
#             BuildKit::Utilities::Console.terminate_with_err "Invalid platform option for distribute task. Choose one of: hockeyapp, testflight"
#         end
#         complete_task!
#       end

#       private

#       def assert_requirements
#         BuildKit::Utilities::Assertions.assert_tasks_completed [:increment_version], @runner
#         BuildKit::Utilities::Assertions.assert_tasks_completed [:create_ipa], @runner
#       end

#       def distribute_with_hockeyapp
#         BuildKit::Utilities::Console.terminate_with_err "Invalid HockeyApp token" if @task_options[:token].nil?
#         file_arg = "-f '#{@runner.store[:artefact_created]}'"
#         token_arg = "--token '#{@task_options[:token]}'"
#         message_arg = "-m '#{@runner.store[:new_version_number][:full]}'"
#         @output = %x["ipa distribute:hockeyapp #{file_arg} #{token_arg} #{message_arg}"]
#         puts @output
#       end

#       def distribute_with_testflight
#         puts "TestFlight not yet supported"
#       end

#       def distribute_succeeded?
#         @output.include? "EXIT CODE: 0"
#       end

#       def complete_task!
#         @runner.store[:distribute_succeeded] = distribute_succeeded?
#         message = (distribute_succeeded?) ? "distribute completed, distributed successfully" : "distribute task completed, but the distribution failed"
#         @runner.task_completed! :distribute, message, @output 
#       end

#     end

#   end
  
# end