require "sequel"

require_relative "yaml_config_loader"

# does two things.
# 1. creates a sequel client object using the conect mention.
# 2. creates a sequel object method using the yml file.
# not really built like a factory but
#
# For 1.
# used externally. when gems calls this.
# basically init it with sommethig, the call connect.
# take the return object.
# basically DRY up the params.
#
# For 2.
# used interally to test if the gem work like its suppose to.
# db settings is configured in yml file.
# and it will return a object from that and connect.
#
# so not really a factory in the true sense.
# just DRY a few things.
class SequelFactory

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
    #self.connect
  end

  # connects to db.
  # and return a sequel object that is connected to the db.
  def connect
    return @client = Sequel.connect(:adapter => @adapter,
                             :host => @host,
                             :database => @database,
                             :user => @user,
                             :password => @password)
  end

  # NOTE. YOU DONT NEED THIS...
  # yaml_config_loader has a db_params
  # you should use that.
  # pass in the rspec to the actual objects.
  #
  # want this for internally test suite use.
  # just a connection to the internal test db.
  # only use this in the spec directory.
  def self.connect_test_db
    ycl = YAMLConfigLoader.new
    return Sequel.connect(ycl.db_con_params)
  end

end
