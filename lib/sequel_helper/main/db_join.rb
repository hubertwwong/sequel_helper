require_relative "db_base"
require_relative "../util/log_factory"

class DBJoin < DBBase

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
  #
  # things of note.
  # table cols is an array.
  # left_outer_join takes prefixes the right_table and left table
  # so you need it in this format
  #   rcol1 => lcol1
  def left_join_null(left_table:, right_table:, right_col:, left_col:)
    full_left_col = left_table.to_s + "." + left_col.to_s
    result = @client[left_table].left_outer_join(right_table, right_col => left_col).where(full_left_col => nil)
    
    @log.debug "aaaaaaaaaaaaaaa"
    @log.debug result
    result.each do |i|
      @log.debug i
    end
    @log.debug "bbbbbbbbbbbbbb"
    
    return result
  end
  
end