require_relative "db_base"
require_relative "../util/log_factory"

class DBImport < DBBase

  def initialize(db_params)
    super(db_params)
    @log = LogFactory.build
  end

  # imports a csv from a table.
  # load it into a db...
  def import_csv
  end

  # import a csv into a table
  def load_data
  end

end
