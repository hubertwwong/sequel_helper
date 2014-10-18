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
  # 1. clone_and_load
  # 2. fetch most recent date from orig table.
  # 3. copy data over. based of date from 4.
  def import_csv_lite_date(csv_params:, 
                           table_name:, 
                           table_cols:, 
                           date_col_name:, 
                           date_val:)
    
    # using table name temp load the intial csv
    # and then updating the results back in.
    table_name_temp = table_name.to_s + "_clone"
    
    # 1. clone and load
    ###################
    self.clone_and_load(csv_params: csv_params, 
                        table_name: table_name, 
                        table_cols: table_cols)
    
    # 2. fetch date
    ################
    recent_row = @db_insert.client[table_name].reverse_order(date_col_name).first
    most_recent_date = recent_row[date_col_name]
    @log.debug ">>" + date_col_name.to_s
    @log.debug ">>" + most_recent_date.to_s
    
    # 3. update.
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

  # import new values. does not an update.
  # you define the key cols that it checks against
  #
  # 1. clone and load
  # 2. look for new items in the csv.
  # 3. copy data over. based of date from 4.
  def import_csv_new(csv_params:, 
                     table_name:, 
                     table_cols:)
    # using table name temp load the intial csv
    # and then updating the results back in.
    table_name_temp = table_name.to_s + "_clone"
    
    # 1. clone and load
    ###################
    self.clone_and_load(csv_params: csv_params, 
                        table_name: table_name, 
                        table_cols: table_cols)
    
    # 2. compare clone and orig table.
    ##################################
    
    # 3. 
    
    return false
  end
  
  # just an idea..
  # but have a smarter import csv
  # check a few values against the csv.
  # see if it matches.
  # then, update when there are diffs.
  # maybe against one param. like a date or a primary key.
  # check 2 or 3. then start...
  #
  # will do these things.
  # 1. drop the clone table if it exist.
  # 2. create a new clone table of the table to you want to insert to.
  # 3. load data the csv into the clone table.
  # 4. join...
  # 5. update...
  def import_csv_smart
  
  end
  
  # import csv... probably will have a heavy version at some point..
  # my hunch is that you will need it still.
  # wont blow out the id fields.
  # 
  # 
  def import_csv_full
    
  end
  
  # Util Methods
  ############################################################################
  
  # clone and load the csv into the clone table.
  #
  # will do these things.
  # 1. drop the clone table if it exist.
  #      assumes that the table is called {:table_name}_clone.
  # 2. create a new clone table of the table to you want to insert to.
  # 3. load data the csv into the clone table. 
  def clone_and_load(csv_params:, table_name:, table_cols:)
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
    
    # need a return.... what?
    return false
  end
  
end