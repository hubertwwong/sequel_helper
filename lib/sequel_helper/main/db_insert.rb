require_relative "db_base"
require_relative "../gen/gen_insert"
require_relative "../util/log_factory"

class DBInsert < DBBase

  def initialize(db_params)
    super(db_params)
    @log = LogFactory.build
  end

  # copies rows from a src table to a dest table.
  # using a where param..
  #
  # src_table - source table to insert from. might be from a raw data dump.
  # dest_table - table dump.
  # table_cols - array of table col names. source and dest to match to simplify.
  # where_params - see sequel where stmt for details. i dont think you can pass {}
  def import_from(src_table, dest_table, table_cols, where_param)
    #@client.loggers << @log
    # copy from src to dest.
    return @client[dest_table].import(table_cols,
             @client[src_table].select(*table_cols).where(where_param))
    # splat operator. so if you * in front on an array, it will explode it.
  end

  # inserts based of another table.
  # useful when copying rows between tables.
  # DO NOT USE...
  def insert_select(params = {})
    db_str = GenInsert.insert_select(params)
    #@log.debug db_str
    @client.run db_str

    return true
  end

end
