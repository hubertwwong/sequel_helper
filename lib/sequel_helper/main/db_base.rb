require "sequel"

require_relative "sequel_factory"
require_relative "../util/log_factory"

# a simple base class that will contain a simple init and a sequel instance var.
# DRY things up.
class DBBase

  # sequel object and log object.
  attr_accessor :client, :log

  # connect to the db.
  def initialize(db_params)
    sf = SequelFactory.new(db_params)
    @client = sf.connect
    @log = LogFactory.build
  end

end
