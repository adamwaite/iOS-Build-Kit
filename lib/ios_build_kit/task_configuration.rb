require 'ostruct'

module BuildKit
  
	module Runner

	  class TaskRunnerConfig < OpenStruct
      def absolute_build_dir
        File.expand_path(build_dir)
      end
	  end

 end
  
end