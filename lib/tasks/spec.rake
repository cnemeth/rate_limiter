if defined?(RSpec)

  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec)

  task("spec").clear
  task("spec:all").clear
  task("spec:services").clear
  task("spec:requests").clear

  task default: 'spec'
  task :spec do
    Rake::Task['spec:all'].invoke
    Rake::Task['spec:services'].invoke
    Rake::Task['spec:requests'].invoke
  end

  namespace :spec do
    desc "Run all specs in spec directory (excluding services and requests specs)"
    RSpec::Core::RakeTask.new(:all) do |t|
      t.pattern = [:models, :controllers, :views, :helpers, :mailers, :lib, :routing].collect do |sub|
        "./spec/#{sub}/**/*_spec.rb"
      end
    end

    desc "Run the code examples in spec/services directory"
    RSpec::Core::RakeTask.new(:services) do |t|
      t.pattern = './spec/services/**/*_spec.rb'
    end

    desc "Run the code examples in spec/requests directory"
    RSpec::Core::RakeTask.new(:requests) do |t|
      t.pattern = './spec/requests/**/*_spec.rb'
    end
  end
end
