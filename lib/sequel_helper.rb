require "rubygems"
require "sequel"
require "mysql2"

class SequelHelper
  
  attr_accessor :client, :url, :user, :password, :db_name, :table_name, :filename
  
  def initialize(params = {})
    # make the params optional.
    params = {
              client: nil,
              url: nil, 
              user: nil, 
              password: nil,
              db_name: nil,
              table_name: nil,
              filename: nil
             }.merge(params)
    
    # load params into instance variables.
    @url = params.fetch(:url)
    @user = params.fetch(:user)
    @password = params.fetch(:password)
    @db_name = params.fetch(:db_name)
    @table_name = params.fetch(:table_name)
    @filename = params.fetch(:filename)
    
    # connect to db.
    self.connect
  end
  
  def load_data(params = {})
    final_params = self.inject_db_params_with_filename(params)
    gld = GenLoadData.create(final_params)
    
    # run the query if its returns a string and not false
    if gld != false
      @client.query(gld)
    else
      return false
    end
  end
  
  # helper methods
  ############################################################################
  
  # inject_db_params_with_filename
  #
  # injects the db_name, table_name, and file_name
  # into the param hash.
  # used for the string generation functions.
  def inject_db_params_with_filename(params = {})
    injected_params = params
    injected_params[:db_name] = @db_Name
    injected_params[:table_name] = @table_name
    injected_params[:filename] = @filename
    
    return injected_params
  end
  
  # inject_db_params
  #
  # injects the db_name, table_name
  # into the param hash.
  # used for the string generation functions.
  def inject_db_params(params = {})
    injected_params = params
    injected_params[:db_name] = @db_Name
    injected_params[:table_name] = @table_name
    
    return injected_params
  end
  
  # connections
  ############################################################################
  
  # connects to db.
  def connect
    # connect to db.      
    @client = Mysql2::Client.new(:host => @url, 
                             :database => @db_name,
                             :username => @user, 
                             :password => @password)
  end
  
  # close the db connection.
  # might need to call this if the one in the mysql2 client
  # is not fast enough.
  def close
    @client
  end
  
  # TEMP
  ############################################################################
  
  # used to test if the class is setup correcty.
  def hello
    "hello"
  end
    
end