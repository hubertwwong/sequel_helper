require "sequel"

# simple wrapper for the sequel client...
# probably not much more that connect and disconnect...
# dont add a yml loader...
# you need this to work externally.
class ClientHelper

  attr_accessor :adapter, :host, :client, :user, :password, :database

  def initialize(params = {})
    # make the params optional.
    params = {
              adapter: nil,
              host: nil,
              client: nil,
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

    puts "sequel_helper init params"
    puts params.to_s

    # @client is the sequel object.
    # when its connected.

    # connect to db.
    self.connect
  end

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
  # also.. why is it not close... i was useing that before
  def disconnect
    @client.disconnect
  end

  # lets say you have some custom stuff...
  # and you want to tell what type of db...
  # call this... build out some is methods
  # and then call it...
end
