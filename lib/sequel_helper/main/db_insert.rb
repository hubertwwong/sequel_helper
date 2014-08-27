require_relative "../gen/gen_insert"

class DBInsert < DBBase

  def initialize(db_params)
    super(db_params)
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
