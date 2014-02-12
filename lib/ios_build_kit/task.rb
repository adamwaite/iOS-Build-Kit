module BuildKit
  
	module Tasks

		class BuildKitTask

			attr_reader :runner, :config, :task_options

			def initialize(attributes = {})
        prepare_task_with_runner_and_options! attributes[:runner], attributes[:opts]
      end

			def prepare_task_with_runner_and_options! runner, opts
      	@runner = runner
      	@config = runner.config
      	@task_options = opts
        assert_requirements
      end

		end

	end
 
end