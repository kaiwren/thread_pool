puts "Building on Ruby #{RUBY_VERSION}, #{RUBY_RELEASE_DATE}, #{RUBY_PLATFORM}"

require 'rubygems'
gem 'rspec', '>= 1.2.8'
require 'rake'
require 'spec'
require 'spec/rake/spectask'


desc 'Default: run spec tests.'
task :default => :spec

desc "Run all specs"
Spec::Rake::SpecTask.new(:spec) do |task|
  task.spec_files = FileList['spec/**/*_spec.rb']
  task.spec_opts = ['--options', 'spec/spec.opts']
end

namespace :thread_pool do
  desc "Build Gem"
  task :build_gem do |task|
    system "gem build thread_pool.gemspec;"
  end
  
  desc "Install Gem"
  task :install_gem do |task|
    system "sudo gem uninstall thread_pool; sudo gem install thread_pool"
  end
end
