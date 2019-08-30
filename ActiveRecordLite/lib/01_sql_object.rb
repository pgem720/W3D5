require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    return @columns if @columns 
    columns = DBConnection.execute2(<<-SQL)
    SELECT
      *
    FROM
      "#{table_name}"
    SQL
    @columns = columns.first.map {|col| col.to_sym}
  end

  def self.finalize!
    columns = self.columns
    
    columns.each do |column|
      define_method("#{column}") do
        self.attributes[column] 
      end
      
      define_method("#{column}=") do |p|
        self.attributes[column] = p
      end
    end

  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.to_s.tableize
  end

  def self.all
    results = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
    SQL
    self.parse_all(results)
  end

  def self.parse_all(results)
    results.map do |result|
      self.new(result)
    end
    
  end

  def self.find(id)
    DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
    SQL
    
  end

  def initialize(params = {})
    params.each do |k,v|
      k = k.to_sym
      if !self.class.columns.include?(k)
        raise "unknown attribute '#{k}'" 
      end
      self.send("#{k}=", v)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    # ...
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
