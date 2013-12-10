require "sequel"

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
    @database = params.fetch(:db_name)
    
    # @client is the sequel object.
    # when its connected.
    
    # connect to db.
    self.connect
  end
  
  
  
  # SELECT methods
  ############################################################################
  
  def select(params = {})
    return "pie"
  end
  
  
  # MISC METHODS
  ############################################################################
  
  # convert sequel results to an array of hashes.
  # in sequel, results are in its own data struct.
  # if you call all rows, it returns as an array of hashes.
  # if you do a where call, you can call this on the results
  # so it will return it as an array of hashes.
  def to_array_of_hashes(sequel_results)
    if sequel_results == nil
      return nil
    else
      result = Array.new
      sequel_results.each do |item|
        result.push(item)  
      end
      return result
    end
  end

  # inject_db_params
  # might not nbe needed.
  def inject_db_params(params = {})
    injected_params = params
    injected_params[:database] = @database
    
    return injected_params
  end
  
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
    @client
  end
  
  # TEMP
  ############################################################################
  
  # used to test if the class is setup correcty.
  def hello
    "hello"
  end
    
end