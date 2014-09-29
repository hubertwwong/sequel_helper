require_relative "db_base"
require_relative "db_table"
require_relative "db_load_data"
require_relative "../util/log_factory"

class DBImport < DBBase

  def initialize(db_params)
    super(db_params)
    @db_table = DBTable.new(db_params)
    @db_load_data = DBLoadData.new(db_params)
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
  # 4. copy data over. based of date.
  def import_csv_lite_date(params = {})
     # load params into instance variables.
    ######################################
    csv_params = params.fetch(:csv_params)
    table_name_orig = params.fetch(:table_name)
    table_cols = params.fetch(:table_cols)
    # column names of the table that you are working on.
    # just needs to be the stuff that you are inserting.
    key_cols = params.fetch(:key_cols)
    # keys that you want to match against
    # it could be an id or a
    table_name_temp = table_name_orig.to_s + "_clone"
    # adding the sql table name so you can distinguish col from one table
    # to another.
    #table_name_orig_s = table_name_orig.to_s + " o"
    #table_name_temp_s = table_name_orig.to_s + "clone t"

    # -1 debugging
    ##############
    
    
    # 0. drop temp table if exist.
    ##############################
    @client.drop_table? table_name_orig.to_s + "_clone"

    # 1. clone temp table.
    ######################

    @db_table.clone(table_name_orig.to_s)
    #@log.debug ">> CLONING TABLE " + table_name_orig.to_s + " t " + table_name_temp + " " + Time.now.to_s
    #puts ">> CLONING TABLE " + table_name_orig.to_s + " t " + table_name_temp + " " + Time.now.to_s

    # 3. load data
    ##############
    csv_params[:table_name] = table_name_orig.to_s + "_clone"
    @db_load_data.load_data csv_params
    
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