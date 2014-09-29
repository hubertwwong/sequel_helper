require "pathname"

require_relative "db_base"
require_relative "../gen/gen_load_data"
require_relative "../util/log_factory"

class DBLoadData < DBBase

  def initialize(db_params)
    super(db_params)
    @log = LogFactory.build
  end

  # using the high speed csv import instead of load rows one at a time.
  # only using MYSQL for now...
  # replace if you find the sequel alternative.
  #
  # see gen load data.... for detail
  #
  # adding a hard coded method. copy to temp
  # delete it after import.
  #
  # and returns true if its successful. might want to change it...
  #
  def load_data(ld_params)
    # copy to /tmp so sql can access it.
    cmd_status = system "cp -rf " + ld_params[:filename] + " /tmp"

    # bail if system returns anything other than true.
    if cmd_status != true
      return cmd_status
    end

    # build new filepath...
    pn = Pathname.new(ld_params[:filename])
    pn_final = Pathname.new("/tmp/" + pn.basename.to_s)

    # reload temp param with new file path.
    ld_params[:filename] = pn_final.to_s

    # generate SQL string
    db_str = GenLoadData.load_data ld_params

    # run SQL query
    # wrap in a transaction.
    # will fail on return
    result = nil
    @client.transaction do
      result = @client.run db_str
    end
      
    # delete the file that you copied.
    cmd_status = system "rm " + pn_final.to_s

    # return sql result. in case of error.
    return true
  end

end