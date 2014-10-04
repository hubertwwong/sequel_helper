require_relative "db_base"
require_relative "db_insert"
require_relative "db_load_data"
require_relative "db_table"
require_relative "../util/log_factory"

class DBImport < DBBase

  def initialize(db_params)
    super(db_params)
    @db_insert = DBInsert.new(db_params)
    @db_load_data = DBLoadData.new(db_params)
    @db_table = DBTable.new(db_params)
    @log = LogFactory.build
  end

  # imports a csv to a table
  # but this is a lite version
  # the only check this is going to do is update the date
  #
  # will do these things.
  # 1. drop the clone table if it exist.
  # 2. create a new clone table of the table to you want to insert to.
  # 3. load data the csv into the clone table.
  # 4. fetch most recent date from orig table.
  # 5. copy data over. based of date from 4.
  def import_csv_lite_date(csv_params:, table_name:, table_cols:, date_col_name:, date_val:)
    # using table name temp load the intial csv
    # and then updating the results back in.
    table_name_temp = table_name.to_s + "_clone"
    
    # -1 debugging
    ##############
    
    
    # 0. drop temp table if exist.
    ##############################
    @client.drop_table? table_name_temp

    # 1. clone temp table.
    ######################

    @db_table.clone(table_name.to_s)
    #@log.debug ">> CLONING TABLE " + table_name_orig.to_s + " t " + table_name_temp + " " + Time.now.to_s
    #puts ">> CLONING TABLE " + table_name_orig.to_s + " t " + table_name_temp + " " + Time.now.to_s

    # 3. load data
    ##############
    csv_params[:table_name] = table_name.to_s + "_clone"
    @db_load_data.load_data csv_params
    
    # 4. fetch date
    ################
    recent_row = @db_insert.client[table_name].reverse_order(date_col_name).first
    most_recent_date = recent_row[date_col_name]
    @log.debug ">>" + date_col_name.to_s
    @log.debug ">>" + most_recent_date.to_s
    
    # 4. update.
    ############
    # Insert back the rows that are missing.
    # using the date param.
    where_param = date_col_name.to_s +  " > ?", date_val.to_s
    @db_insert.import_from src_table: table_name_temp.to_sym, 
                           dest_table: table_name.to_sym, 
                           table_cols: table_cols, 
                           where_param: where_param
    
    return false
  end
  
  # just an idea..
  # but have a smarter import csv
  # check a few values against the csv.
  # see if it matches.
  # then, update when there are diffs.
  # maybe against one param. like a date or a primary key.
  # check 2 or 3. then start...
  def import_csv_smart
  end

  # import csv... probably will have a heavy version at some point..
  # just keep this as a remider nnot to have a heavy..
  def import_csv
  end
  
end