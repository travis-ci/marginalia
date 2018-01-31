class TestHelpers
  def self.create_db(db_name:, db_port:, log_file:)
    PgInstance.create(db_name, db_port, log_file)
  end

  def self.file_contains_string(file, string)
    File.foreach(file) do |line|
      return true if line.include?(string)
    end
    false
  end

  def self.truncate_file(file)
    File.truncate(file, 0)
  end
end

class PgInstance
  attr_reader :directory, :port, :db_name, :db_log_file

  def initialize(directory, name, port, log_file)
    @directory = directory
    @port = port
    @db_name = name
    @db_log_file = log_file
  end

  def self.create(name, port, log_file)
    dir = "tmp"
    self.initialize_pg_cluster(dir)
    self.start_cluster(port, dir, log_file)
    self.create_db(port, name)
    new(dir, name, port, log_file)
  end

  def self.initialize_pg_cluster(dir)
    if !ENV['TRAVIS']
      %x[initdb -A trust -D#{dir}]
    end
  end

  def self.start_cluster(port, dir, log_file)
    if !ENV['TRAVIS']
      %x[pg_ctl -o"-p #{port}" -D#{dir} -l#{log_file} start]
    end
  end

  def self.create_db(port, name)
    %x[createdb -p#{port} #{name}]
  end

  def self.stop_cluster(port, directory)
    system("pg_ctl -o'-p #{port}' -D#{directory} stop") if File.directory?("tmp")
  end
end
