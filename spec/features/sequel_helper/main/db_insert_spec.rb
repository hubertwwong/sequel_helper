require_relative "../../../../lib/sequel_helper/main/db_insert"
require_relative "../../../../lib/sequel_helper/util/log_factory"
require_relative "../../../../lib/sequel_helper/main/yaml_config_loader"

describe DBInsert do

  let(:db_params) {
      ycl = YAMLConfigLoader.new
      ycl.db_con_params
    }

  before(:all) do
    @log = LogFactory.build
  end

  describe "main" do
    let(:db_params) {
        ycl = YAMLConfigLoader.new
        ycl.db_con_params
      }

    before(:each) do
      # table name
      @orig_table = :orig_table22
      @insert_table = :insert_update22
      @col_name1 = :name1
      @col_start_date = :start_date

      # db init.
      @dbi = DBInsert.new(db_params)

      # delete tables.
      begin
        @dbi.client.drop_table @orig_table
        @dbi.client.drop_table @insert_table
      rescue Sequel::Error => e
        @log.debug e
      end

      # create a table
      # table creation need symbols for col names.
      # can't use instance variables for some reason.
      begin
        @dbi.client.create_table @orig_table do
          primary_key :id
          String :name1
          DateTime :start_date
        end
        @dbi.client.create_table @insert_table do
          primary_key :id
          String :name1
          DateTime :start_date
        end
      rescue Sequel::Error => e
        @log.debug e
      end

      #@log.debug @orig_table
      #@log.debug @col_name1
      #@log.debug @roe_val_foo
      #@log.debug @roe_val_bar

      # insert some table in orig table...
      100.times do |i|
        @dbi.client[@orig_table.to_sym].insert(
          [@col_name1, @col_start_date], ["name" + i.to_s, (Date.today-i)])
      end
    end

    describe "connect" do
      xit "basic" do
        dbq = DBInsert.new(db_params)
        expect(dbq.client.test_connection).to be == true
      end
    end

    describe "import_from" do
      it "basic" do
        where_param = "start_date > ?", (Date.today-4)
        where_param = "start_date > ?", "2014-09-10"
        result = @dbi.import_from(@orig_table, @insert_table, [:name1, :start_date], where_param)
        expect(result).to be == 0
      end
    end
  end

end
