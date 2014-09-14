require_relative "db_base"
require_relative "../util/log_factory"

class DBTable < DBBase

  def initialize(db_params)
    super(db_params)
    @log = LogFactory.build
  end

  # clones a table.
  # MYSQL SYNTAX.
  #
  # takes symbol... or should do.
  def clone_table(orig_name, new_name)
    @client.run "CREATE TABLE " + new_name.to_s + " LIKE " + orig_name.to_s + ";"
  end

end
