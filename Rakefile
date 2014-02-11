require "bundler/setup"

gemspec = eval(File.read("ios_build_kit.gemspec"))

task :build => "#{gemspec.full_name}.gem"

file "#{gemspec.full_name}.gem" => gemspec.files + ["ios_build_kit.gemspec"] do
  system "gem build ios_build_kit.gemspec"
end