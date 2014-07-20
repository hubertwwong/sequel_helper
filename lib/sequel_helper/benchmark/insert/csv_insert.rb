# some simple test to see what performance is like on some basic mysql tweaks
class CSVInsert

  attr_accessor :adapter, :host, :client, :user, :password, :database, :sh

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

    @sh = SequelHelper.new(params)

    @sh.connect
  end

  # COMMON.
  ############################################################################

  def drop_table
    @sh.client.run "DROP TABLE IF EXISTS users"
  end

  def create_table
	@sh.client.run "CREATE TABLE IF NOT EXISTS users (" +
                     " id INT(11) NOT NULL AUTO_INCREMENT," +
                     " first VARCHAR(255) NOT NULL," +
                     " last VARCHAR(255) NOT NULL," +
                     " PRIMARY KEY (id)" +
                     " );"
  end

  # really naive insert.
  def insert_rows(x)
    @sh.client.run "START TRANSACTION;"
      (0..x).each do |i|
        sql_str = "INSERT INTO users" +
                         " (first, last)" +
                         " VALUES" +
                         " ("+
                         " 'foo" + i.to_s + "', " +
                         " 'bar" + (i%100).to_s + "'" +
                         " );"
        #puts sql_str + "<<<<<<<<"
        @sh.client.run sql_str
      end
    @sh.client.run "COMMIT;"
  end

end
