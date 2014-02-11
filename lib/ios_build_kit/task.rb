module BuildKit
  
	module Tasks

		class BuildKitTask

			attr_reader :runner, :config

			def initialize(attributes = {})
        prepare_task_with_runner attributes[:runner]
      end

			def prepare_task_with_runner runner
      	@runner = runner
      	@config = runner.config
        assert_requirements
      end

		end

	end
 
end