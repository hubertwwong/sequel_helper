require "sequel"

require_relative "sequel_factory"
require_relative "../gen/gen_insert"

class DBInsert

  attr_accessor :client

  # connect to the db.
  def initialize(db_params)
    sf = SequelFactory.new(db_params)
    @client = sf.connect
  end

  # inserts based of another table.
  # useful when copying rows between tables.
  def insert_select(params = {})
    db_str = GenInsert.insert_select(params)
    puts db_str
    @client.run db_str

    return true
  end

end
