#!/usr/bin/env rake
require "bundler/gem_tasks"
require_relative "test/test_helpers"
require "tempfile"

DB_PORT=ENV['MARGINALIA_DB_PORT'] || 5455
DB_NAME='marginalia_test'
LOG_FILE=ENV['MARGINALIA_LOG_FILE'] || "tmp/marginalia_log"

namespace :test do
  desc "test all drivers"
  task :all => [:mysql2, :postgresql, :sqlite]

  desc "test mysql driver"
  task :mysql do
    sh "DRIVER=mysql bundle exec ruby -Ilib -Itest test/*_test.rb"
  end

  desc "test mysql2 driver"
  task :mysql2 do
    sh "DRIVER=mysql2 bundle exec ruby -Ilib -Itest test/*_test.rb"
  end

  desc "test PostgreSQL driver"
  task :postgresql do
    sh "DRIVER=postgresql DB_USERNAME=postgres bundle exec ruby -Ilib -Itest test/*_test.rb"
  end

  desc "test sqlite3 driver"
  task :sqlite do
    sh "DRIVER=sqlite3 bundle exec ruby -Ilib -Itest test/*_test.rb"
  end
end

namespace :db do
  desc "reset all databases"
  task :reset => [:"postgresql:reset"]

  namespace :postgresql do
    desc "reset PostgreSQL database"
    task :reset => [:drop, :create]

    desc "create PostgreSQL database"
    task :create do
      instance = TestHelpers.create_db(
        db_name: DB_NAME,
        db_port: DB_PORT,
        log_file: LOG_FILE,
      )
    end

    desc "kill PostgreSQL database"
    task :drop do
      PgInstance.stop_cluster(DB_PORT, "tmp")
      %x[rm -rf "tmp"] unless ENV['TRAVIS']
    end
  end
end
