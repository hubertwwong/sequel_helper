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
  # second param is optionnal.
  # if you dont supply one, it will append the string "_clone"
  def clone(orig_name, new_name=nil)
    if new_name == nil
      result_sql = GenTable.clone(orig_name, orig_name.to_s + "_clone")
    else
      result_sql = GenTable.clone(orig_name, new_name)
    end
    @log.debug result_sql
    @client.run result_sql
  end

end
