require "sequel"

require_relative "sequel_helper/gen/gen_load_data"
require_relative "sequel_helper/gen/gen_insert"

class SequelHelper
  
  attr_accessor :adapter, :host, :client, :user, :password, :database
  
  def initialize(params = {})
    # make the params optional.
    params = {
              adapter: nil,
              host: nil,
              client: nil,
              url: nil, 
              user: nil, 
              password: nil,
              database: nil
             }.merge(params)
    
    # load params into instance variables.
    @adapter = params.fetch(:adapter)
    @host = params.fetch(:host)
    @user = params.fetch(:user)
    @password = params.fetch(:password)
    @database = params.fetch(:database)
    
    # @client is the sequel object.
    # when its connected.
    
    # connect to db.
    self.connect
  end
  
  
  
  
  # LOAD DATA methods
  ############################################################################
  
  # imports csv into a table.
  def load_data(params = {})
    db_str = GenLoadData.load_data(params)
    @client.run db_str
    return true
  end
  
  
  
  
  # TABLE methods
  ############################################################################
  
  # clones a table.
  def clone_table(orig_name, new_name)
    @client.run "CREATE TABLE " + new_name + " LIKE " + orig_name + ";" 
  end
  
  
  
  # INSERT methods
  ############################################################################
  
  # checks to see if the row values are not in the db before you insert.
  # **** DELETE THIS *****
  def insert_unique(table_name, insert_param)
    #puts table_name
    #puts insert_param.inspect
    if !self.row_exist?(table_name, insert_param)
      tab = @client.from(table_name).insert(insert_param)
      return true
    else
      return false
    end
  end
  
  # WORKING ON IT...
  # broken...
  #def insert_select_not_found(table_name)
  #  insert_stmt = "date, symbol, open, high, low, close, adj_close, volume"
  #  select_stmt = ""
  #  @client[:fleet].insert(insert_stmt).select(select_stmt).sql
  #end
  
  # insert select statement.
  # allows you to insert based off a table view.
  def insert_select(params = {})
    db_str = GenInsert.insert_select(params)
    @client.run db_str
    return true
  end
  
  
  
  # SELECT methods
  ############################################################################
  
  #def select(params = {})
  #  puts "KAHAN..................."
  #  return "pie"
  #end
  
  
  
  # QUERY methods
  ############################################################################
  
  # checks if a row with a given constraint exist.
  def row_exist?(table_name, where_param)
    # note that you need the all so it actually runs
    # this applies for all queries for sequel.
    result = @client.from(table_name).where(where_param).all
    
    if result == nil || result.length == 0
      #puts 'row does not exist'
      return false
    else
      #puts 'row exist'
      return true
    end
  end
  
  
  
  # CSV_IMPORT methods
  ############################################################################
  
  # imports a csv into an existing table...
  #
  # has to take a round about way to do since LOAD DATA has some weird quirks.
  # it won't check the if the rows exist before inserting.
  # so this function will handle that...
  # 
  # basically it does this.
  # 1. create a temp table. using the like command.
  # 2. load csv data into this table.
  # 3. make a select statement, that compares the temp table against the actual
  #    table you want to insert. this will return rows that don't exist.
  #    insert into the original table. (3 and 4 are 1 SQL statement...)
  # 5. (optional...) might add an update existing feature
  # 6. delete temp table.
  #
  def import_csv(params={})
    # load params into instance variables.
    csv_params = params.fetch(:csv_params)
    table_name_orig = params.fetch(:table_name)
    table_cols = params.fetch(:table_cols)
    # column names of the table that you are working on.
    # just needs to be the stuff that you are inserting.
    key_cols = params.fetch(:key_cols)
    # keys that you want to match against
    # it could be an id or a
    table_name_temp = table_name_orig + "temp"
    # adding the sql table name so you can distinguish col from one table
    # to another.
    table_name_orig_s = table_name_orig + " o"
    table_name_temp_s = table_name_orig + "temp t"
    
    # 1. clone temp table.
    self.clone_table(table_name_orig, table_name_temp)
    
    # 2. load csv into table.
    # need to use the temp table to load the csvv
    # not the original one.
    csv_params[:table_name] = table_name_temp
    self.load_data(csv_params)
    
    # create the select statement....
    select_str = "t." + table_cols[0]
    table_cols.each_with_index do |table_col, i|
      # skip the first item since you used it already.
      if i != 0
        select_str = select_str + ", " + "t." + table_col
      end
    end
    
    # need to prefix the key cols with the sql table name.
    # 
    # looks like this.
    # f.date=b.date AND f.symbol=b.symbol
    on_str = "o." + key_cols[0] + "=t." + key_cols[0]
    key_cols.each_with_index do |key_col, i|
      # skip the first item since you used it already.
      if i != 0
        on_str = on_str + " AND " + "o." + key_col + "=t." + key_col
      end
    end
    
    # creating the where statement...
    # using the keys cols...
    # after the join, you are checking for keys that are null.
    # these are basically the rows that you haven't seen yet and want to insert.
    where_str = "o." + key_cols[0] + " IS NULL"
    key_cols.each_with_index do |key_col, i|
      # skip the first item since you used it already.
      if i != 0
        where_str = where_str + " AND " + "o." + key_col + " IS NULL"
      end
    end
    
    # 3. insert select statement.
    insert_params = {:table_name => table_name_orig,
                     :into_flag => true,
                     :table_cols => table_cols,
                     :select_stmt => select_str +
                        " FROM " + table_name_temp_s + " LEFT JOIN " + table_name_orig_s +
                        " ON " + on_str +
                        " WHERE "+ where_str}
    self.insert_select insert_params
    
    # the update... remember that the temp table...
    # is the one that has all of the data..
    # in this case, the temp table is foo, not bar..
    #UPDATE foo f LEFT JOIN bar b ON f.symbol=b.symbol AND f.date=b.date
    #SET b.open=f.open, b.high=f.high, b.low=f.low, b.close=f.close, b.adj_close=f.adj_close, b.volume=f.volume;
    
    # 4. drop the temp table.
    @client.drop_table table_name_temp 
    
    return true
  end
  
  
  
  # MISC METHODS
  ############################################################################
  
  # MIGHT NOT BE NEEDED...
  # convert sequel results to an array of hashes.
  # in sequel, results are in its own data struct.
  # if you call all rows, it returns as an array of hashes.
  # if you do a where call, you can call this on the results
  # so it will return it as an array of hashes.
  #def to_array_of_hashes(sequel_results)
  #  if sequel_results == nil
  #    return nil
  #  else
  #    result = Array.new
  #    sequel_results.each do |item|
  #      result.push(item)  
  #    end
  #    return result
  #  end
  #end


  
  # DB Connections
  ############################################################################
  
  # connects to db.
  def connect
    @client = Sequel.connect(:adapter => @adapter, 
                             :host => @host, 
                             :database => @database, 
                             :user => @user, 
                             :password => @password)
  end
  
  # close the db connection.
  # might need to call this if the one in the mysql2 client
  # is not fast enough.
  def close
    @client.close
  end
  
  # TEMP
  ############################################################################
  
  # used to test if the class is setup correcty.
  def hello
    "hello"
  end
    
end