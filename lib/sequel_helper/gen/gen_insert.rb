require_relative "gen_string"

# ACTUALLY.. YOU MIGHT NOT NEED IT>
# Insert statements.
#
class GenInsert

  # insert select syntax...
  #
  # example:
  # INSERT INTO bar (date, symbol, open, high, low, close, adj_close, volume)
  # SELECT f.date, f.symbol, f.open, f.high, f.low, f.close, f.adj_close, f.volume
  #  FROM foo f LEFT JOIN bar b
  #  ON f.date=b.date AND f.symbol=b.symbol
  #  WHERE b.symbol IS NULL;
  def self.insert_select(params={})
    # make some of the params optional.
    params = {
              low_priority_flag: false,
              high_priority_flag: false,
              into_flag: nil,
              ignore_flag: nil
             }.merge(params)

    # load params into variables.
    # ###########################

    table_name = params.fetch(:table_name)
    table_cols = params.fetch(:table_cols)
    select_stmt = params.fetch(:select_stmt)

    # boolean values
    low_priority_flag = params.fetch(:low_priority_flag)
    high_priority_flag = params.fetch(:high_priority_flag)
    into_flag = params.fetch(:into_flag)
    ignore_flag = params.fetch(:ignore_flag)

    # CONSTRUCT DB STR
    ##################
    db_str = "INSERT"

    bool_params = [[low_priority_flag, " LOW_PRIORITY"],
                   [high_priority_flag, " HIGH_PRIORITY"]]
    bool_result = GenString.bool_first(bool_params)
    db_str = GenString.append_not_nil(db_str, bool_result, bool_result)

    db_str = GenString.append_if_true(db_str, " IGNORE", ignore_flag)

    db_str = GenString.append_if_true(db_str, " INTO", into_flag)

    db_str = db_str + " " + table_name
    db_str = db_str + " " + GenString.paren_array_to_comma_str(table_cols)

    db_str = db_str + " SELECT " + select_stmt + ";"

    # debug
    GenString.pp db_str

    return db_str
  end

end
