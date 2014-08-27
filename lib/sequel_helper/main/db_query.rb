require "sequel"

require_relative "sequel_factory"

class DBQuery

  attr_accessor :client

  # connect to the db.
  def initialize(db_params)
    sf = SequelFactory.new(db_params)
    @client = sf.connect
  end

  # checks if a row with a given constraint exist.
  def row_exist?(table_name, where_param=nil)
    # note that you need the all so it actually runs
    # this applies for all queries for sequel.
    result = @client.from(table_name).where(where_param).all

    if result == nil || result.length == 0
      #puts 'row does not exist'
      return false
    else
      #puts 'row exist'
      return true
    end
  end

  def rows(table_name)
    result = @client.from(table_name).all
    return result.length
  end

end
