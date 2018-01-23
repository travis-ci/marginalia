#!/usr/bin/env rake
require "bundler/gem_tasks"

task :default => ['test:all']

namespace :test do
  desc "test all drivers"
  task :all => [:postgresql]

  desc "test PostgreSQL driver"
  task :postgresql do
    sh "DRIVER=postgresql DB_USERNAME=postgres ruby -Ilib -Itest test/escape_test.rb"
    sh "DRIVER=postgresql DB_USERNAME=postgres ruby -Ilib -Itest test/query_comments_test.rb"
  end
end
