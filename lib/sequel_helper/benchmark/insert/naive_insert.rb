# some simple test to see what performance is like on some basic mysql tweaks
class NaiveInsert
  
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
  
  
  def drop_table
    @sh.client.run "DROP TABLE IF EXISTS users"
  end
  
  # naive. very generic way of doing it.
  def create_table1
    @sh.client.run "CREATE TABLE IF NOT EXISTS users (" +
                     " id INT(11) NOT NULL AUTO_INCREMENT," +
                     " first VARCHAR(255) NOT NULL," +
                     " last VARCHAR(255) NOT NULL," +
                     " PRIMARY KEY (id)" +
                     " );"
  end
  
  # really naive insert.
  def insert1(x)
    (0..x).each do |i|
      @sh.client.run "INSERT INTO users" +
                       " (first, last)" +
                       " VALUES" + 
                       " ('foo', 'bar')"
    end
  end
  
  # decrease table size.
  def create_table2
    @sh.client.run "CREATE TABLE IF NOT EXISTS users (" +
                     " id INT(11) NOT NULL AUTO_INCREMENT," +
                     " first VARCHAR(16) NOT NULL," +
                     " last VARCHAR(16) NOT NULL," +
                     " PRIMARY KEY (id)" +
                     " );"
  end
  
  # really naive insert.
  def insert2(x)
    (0..x).each do |i|
      @sh.client.run "INSERT INTO users" +
                       " (first, last)" +
                       " VALUES" + 
                       " ('foo', 'bar')"
    end
  end
  
  # no id.. but larger var char
  def create_table3
    @sh.client.run "CREATE TABLE IF NOT EXISTS users (" +
                     " first VARCHAR(255) NOT NULL," +
                     " last VARCHAR(255) NOT NULL" +
                     " );"
  end
  
  # really naive insert.
  def insert3(x)
    (0..x).each do |i|
      @sh.client.run "INSERT INTO users" +
                       " (first, last)" +
                       " VALUES" + 
                       " ('foo', 'bar')"
    end
  end
  
  # no id.. smaller varchar
  def create_table4
    @sh.client.run "CREATE TABLE IF NOT EXISTS users (" +
                     " first VARCHAR(16) NOT NULL," +
                     " last VARCHAR(16) NOT NULL" +
                     " );"
  end
  
  # really naive insert.
  def insert4(x)
    (0..x).each do |i|
      @sh.client.run "INSERT INTO users" +
                       " (first, last)" +
                       " VALUES" + 
                       " ('foo', 'bar')"
    end
  end
  
  # adding transactions
  def create_table5
    @sh.client.run "CREATE TABLE IF NOT EXISTS users (" +
                     " first VARCHAR(255) NOT NULL," +
                     " last VARCHAR(255) NOT NULL" +
                     " );"
  end
  
  # really naive insert.
  def insert5(x)
    @sh.client.run "START TRANSACTION;"
    (0..x).each do |i|
      @sh.client.run "INSERT INTO users" +
                       " (first, last)" +
                       " VALUES" + 
                       " ('f1oo', 'b1ar')"
    end
    @sh.client.run "COMMIT;"
  end
  
end