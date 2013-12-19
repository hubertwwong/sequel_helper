require "sequel"

require_relative "gen/gen_load_data"

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
  def insert_select_not_found(table_name)
    insert_stmt = "date, symbol, open, high, low, close, adj_close, volume"
    select_stmt = ""
    @client[:fleet].insert(insert_stmt).select(select_stmt).sql
  end
  
  
  
  # SELECT methods
  ############################################################################
  
  #def select(params = {})
  #  puts "KAHAN..................."
  #  return "pie"
  #end
  
  
  
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
  # 4. insert #3 into the original table.
  # 5. (optional...) might add an update existing rows...
  # 6. delete temp table.
  def csv_import(params={})
    
  end
  
  
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


  
  # connections
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