module BuildKit

  Dir["#{File.dirname(__FILE__)}/ios_build_kit/**/*.rb"].each { |f| load(f) }

  def self.start_with_configuration config
    BuildKit::Utilities::Assertions.assert_files_exist [config]
    BuildKit::Utilities::Console.header_msg "BuildKit Run Started"
    runner = BuildKit::Runner::TaskRunner.new({ config_file: config })
  	runner.run_tasks!
  end

end