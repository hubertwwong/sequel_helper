require_relative "db_base"
require_relative "../util/log_factory"

class DBImport < DBBase

  def initialize(db_params)
    super(db_params)
    @log = LogFactory.build
  end

  # does a left join and using a null check on the where param.
  # can use this to figure out rows in one table that are not in a another.
  # assuming both tables have the same table col. think cloning a table
  #
  # this is roughly what the query willl be.
  #
  # SELECT * FROM test_tab_clone c
  # LEFT JOIN test_tab s
  # ON c.col1 = s.col1
  # WHERE s.col1 IS NULL;
  def left_join_null
  
  end
  
end