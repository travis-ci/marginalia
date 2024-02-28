require 'marginalia'
require 'pg'

module Marginalia
  module PgConnectionMonkeyPatch
    def exec(sql, *args)
      puts "EXEC #{sql.inspect}"
      comment = Marginalia.construct_comment
      if comment && comment != "" && !sql.include?(comment)
        super "#{sql} #{comment}", *args
      else
        super sql, *args
      end
    end

    def query(sql, *args)

      puts "QUERY #{sql.inspect}"
      comment = Marginalia.construct_comment
      if comment && comment != "" && !sql.include?(comment)
        super "#{sql} #{comment}", *args
      else
        super sql, *args
      end
    end

    def async_exec(sql, *args)

      puts "A.EXEC #{sql.inspect}"
      comment = Marginalia.construct_comment
      if comment && comment != "" && !sql.include?(comment)
        super "#{sql} #{comment}", *args
      else
        super sql, *args
      end
    end

    def async_query(sql, *args)

      puts "A.QUERY #{sql.inspect}"
      comment = Marginalia.construct_comment
      if comment && comment != "" && !sql.include?(comment)
        super "#{sql} #{comment}", *args
      else
        super sql, *args
      end
    end

    def prepare(statement_name, sql, *args)

      puts "PREP #{sql.inspect}"
      comment = Marginalia.construct_comment
      if comment && comment != "" && !sql.include?(comment)
        super statement_name, "#{sql} #{comment}", *args
      else
        super statement_name, sql, *args
      end
    end
  end
end

module Marginalia
  module PgInstrumentation
    def self.install
      PG::Connection.prepend(Marginalia::PgConnectionMonkeyPatch)
    end
  end
end
