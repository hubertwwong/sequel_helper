require "sequel"

require_relative "sequel_factory"

class DBTable

  attr_accessor :client

  # connect to the db.
  def initialize(db_params)
    sf = SequelFactory.new(db_params)
    @client = sf.connect
  end

  # clones a table.
  # MYSQL SYNTAX.
  def clone_table(orig_name, new_name)
    @client.run "CREATE TABLE " + new_name + " LIKE " + orig_name + ";"
  end

end
