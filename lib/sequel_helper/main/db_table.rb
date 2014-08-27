class DBTable < DBBase

  def initialize(db_params)
    super(db_params)
  end

  # clones a table.
  # MYSQL SYNTAX.
  def clone_table(orig_name, new_name)
    @client.run "CREATE TABLE " + new_name + " LIKE " + orig_name + ";"
  end

end