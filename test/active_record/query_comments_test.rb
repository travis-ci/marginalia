# -*- coding: utf-8 -*-

require "minitest/autorun"
require 'mocha/test_unit'
require 'logger'
require 'pp'
require 'active_record'
require 'tmpdir'

require 'active_record/connection_adapters/postgresql_adapter'
require "test_helpers"

# Shim for compatibility with older versions of MiniTest
MiniTest::Test = MiniTest::Unit::TestCase unless defined?(MiniTest::Test)

# From version 4.1, ActiveRecord expects `Rails.env` to be
# defined if `Rails` is defined
if defined?(Rails) && !defined?(Rails.env)
  module Rails
    def self.env
    end
  end
end

require 'marginalia'
RAILS_ROOT = File.expand_path(File.dirname(__FILE__))

class Post < ActiveRecord::Base
end

class ActiveRecordMarginaliaTest < MiniTest::Test
  DB_PORT=5439
  DB_NAME="active_record_marginalia_test"
  LOG_FILE="active_record_logfile"
  @@db_instance = TestHelpers.create_db(
    db_name: DB_NAME,
    db_port: DB_PORT,
    log_file: LOG_FILE,
  )

  ActiveRecord::Base.establish_connection({
    :adapter  => "postgresql",
    :host     => "localhost",
    :port     => DB_PORT,
    :username => ENV["DB_USERNAME"] || "root",
    :database => DB_NAME,
  })

  unless Post.table_exists?
    ActiveRecord::Schema.define do
      create_table "posts", :force => true do |t|
      end
    end
  end

  def setup
    @queries = []
    ActiveSupport::Notifications.subscribe "sql.active_record" do |*args|
      @queries << args.last[:sql]
    end

    Marginalia.install
    Marginalia.set('app', 'rails')
  end

  def test_double_annotate
    ActiveRecord::Base.connection.expects(:annotate_sql).returns("select id from posts").once
    ActiveRecord::Base.connection.send(:select, "select id from posts")
  ensure
    ActiveRecord::Base.connection.unstub(:annotate_sql)
  end

  # def test_query_commenting_on_postgres_update
  #   ActiveRecord::Base.connection.expects(:annotate_sql).returns("update posts set id = 1").once
  #   ActiveRecord::Base.connection.send(:exec_update, "update posts set id = 1")
  # ensure
  #   ActiveRecord::Base.connection.unstub(:annotate_sql)
  # end

  def test_query_commenting_on_postgres_delete
    ActiveRecord::Base.connection.expects(:annotate_sql).returns("delete from posts where id = 1").once
    ActiveRecord::Base.connection.send(:exec_delete, "delete from posts where id = 1")
  ensure
    ActiveRecord::Base.connection.unstub(:annotate_sql)
  end

  def test_configuring_application
    Marginalia.set('app', 'customapp')
    Post.all.to_a
    assert_match %r{/\*app:customapp\*/$}, @queries.first
  end

  def test_configuring_query_components
    Marginalia.set('controller', 'posts')
    Post.all.to_a
    assert_match %r{/\*app:rails,controller:posts\*/$}, @queries.first
  end

  def teardown
    Marginalia.clear!
    ActiveSupport::Notifications.unsubscribe "sql.active_record"
  end
end
