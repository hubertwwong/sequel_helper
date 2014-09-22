require "pathname"

require_relative "gen_string"

# a string generating class.
# used to generate some mysql commands.
# 
# notes.
# if the file does not exist, this will fail...
# not sure if its a good or bad thing...
class GenLoadData

  attr_accessor :low_priority_flag, :concurrent_flag, :local_flag,
                :replace_flag, :ignore_flag, :skip_num_lines,
                :fields_term_by, :fields_enclosed_by, :fields_escaped_by,
                :line_start_by, :line_term_by, :set_col_names,
                :filename, :table_name

  # constructs the mysql string to insert the data
  def self.load_data(params = {})
    # make some of the params optional.
    params = {
              low_priority_flag: nil,
              concurrent_flag: nil,
              local_flag: nil,
              replace_flag: nil,
              ignore_flag: nil,
              skip_num_lines: nil,
              fields_term_by: nil,
              fields_enclosed_by: nil,
              fields_escaped_by: nil,
              line_start_by: nil,
              line_term_by: nil,
              set_col_names: nil
             }.merge(params)

    # load params into variables.
    # ###########################

    # absolute path for filename.
    filename = params.fetch(:filename)
    table_name = params.fetch(:table_name)

    # boolean values
    low_priority_flag = params.fetch(:low_priority_flag)
    concurrent_flag = params.fetch(:concurrent_flag)
    local_flag = params.fetch(:local_flag)
    replace_flag = params.fetch(:replace_flag)
    ignore_flag = params.fetch(:ignore_flag)

    fields_term_by = params.fetch(:fields_term_by)
    fields_enclosed_by = params.fetch(:fields_enclosed_by)
    fields_escaped_by = params.fetch(:fields_escaped_by)

    line_start_by = params.fetch(:line_start_by)
    line_term_by = params.fetch(:line_term_by)

    skip_num_lines = params.fetch(:skip_num_lines)

    col_names = params.fetch(:col_names)
    set_col_names = params.fetch(:set_col_names)

    # INTIAL CHECKS
    ###############

    # check if path exist.
    # if it doesn't exit the path.
    pn = Pathname.new filename
    if pn.exist? == false
      puts "error: csv does not exist."
      return nil
    end

    if col_names == nil
      puts "error: need to define column names"
      return nil
    end

    if line_term_by == nil
      puts "error: define line terminator. usually \n or \r\n"
      return nil
    end

    # construct the db string.
    ##########################

    # initial sql statemet
    db_str = "LOAD DATA"

    # low priority, concurrent, local
    bool_params = [[low_priority_flag, " LOW_PRIORITY"], [concurrent_flag, " CONCURRENT"]]
    result_str = GenString.bool_first(bool_params)
    db_str = GenString.append_not_nil(db_str, result_str, result_str)

    # file name
    db_str += " INFILE '" + filename + "'"

    # replace / ignore
    bool_params = [[replace_flag, " REPLACE"], [ignore_flag], " IGNORE"]
    result_str = GenString.bool_first(bool_params)
    db_str = GenString.append_not_nil(db_str, result_str, result_str)

    # into table
    db_str += " INTO TABLE " + table_name

    # checks if the optional args fields are used.
    # if its is, add " FIELDS"
    if fields_term_by != nil || fields_enclosed_by != nil || fields_escaped_by != nil
      db_str += " FIELDS"

      if fields_term_by != nil
        db_str += " TERMINATED BY '" +
                 fields_term_by + "'"
      end

      if fields_enclosed_by != nil
        db_str += " ENCLOSED BY '" +
                 fields_enclosed_by + "'"
      end

      if fields_escaped_by != nil
        db_str += " ESCAPED BY '" +
                 fields_escaped_by + "'"
      end
    end

    # check if lines start by or end by is used
    # if it is, add " LINES"
    if line_start_by != nil || line_term_by != nil
      db_str += " LINES"

      if line_start_by != nil
        db_str += " STARTING BY '" +
                 line_start_by + "'"
      end

      if line_term_by != nil
        db_str += " TERMINATED BY '" +
                 line_term_by + "'"
      end
    end

    # if you have titles, add a number to skip those lines
    # so they don't get put into the db.
    if skip_num_lines != nil && skip_num_lines.to_i > 0
      db_str += " IGNORE " + skip_num_lines.to_s + " LINES"
    end
    puts "SKIPLINENUM " + skip_num_lines.to_s + " " + (skip_num_lines != nil && skip_num_lines.to_i > 0).to_s

    # col names
    # define the column names db that correspond csv col
    # if don't wan't to use the column in the csv, use @dummy.
    #
    # example:
    #   ["@dummy", "foo", "bar"]
    db_str += " " + GenString.paren_array_to_comma_str(col_names)

    # set col names
    #
    # use this if you want to modify the CSV input in some way before
    # you write it to the db.
    if set_col_names != nil
      db_str = db_str + " SET"
      result_str = GenString.array_to_comma_str(set_col_names)
      db_str = db_str + " " + result_str
    end

    # add the semi colon
    db_str += ";"

    # debug stuff
    GenString.pp db_str

    return db_str
  end

end