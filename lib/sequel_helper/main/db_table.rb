require_relative "db_base"
require_relative "../gen/gen_table"
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
  def clone(orig_name, new_name)
    @client.run GenTable.clone(orig_name, new_name)
  end

end
