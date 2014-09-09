require_relative "../../../../lib/sequel_helper/main/db_query"
require_relative "../../../../lib/sequel_helper/main/sequel_factory"
require_relative "../../../../lib/sequel_helper/main/yaml_config_loader"
require_relative "../../../../lib/sequel_helper/util/log_factory"


describe "Transaction" do

  let(:dbq) {
      ycl = YAMLConfigLoader.new
      db_params = ycl.db_con_params
      DBQuery.new(db_params)
    }

  before(:all) do
    @log = LogFactory.build
    @db = SequelFactory.connect_test_db
    @db.sql_log_level = :debug
  end

  describe "insert_all_the_things" do
    before(:each) do
      # table name
      @trans_table1 = :trans_table

      # delete tables.
      begin
        @db.drop_table @trans_table1
      rescue Sequel::Error => e
        @log.debug e
      end

      # create a table
      begin
        @db.create_table @trans_table1 do
          primary_key :id
          String :name1
        end
      rescue Sequel::Error => e
        @log.debug e
      end
    end

    # stuck on this...
    # just break out manually..
    xit "should insert 1000 items" do
      @db.transaction do
        (0..100000).each do |i|
          @db[@trans_table1].insert(name1: "foo" + i.to_s )
        end
      end

      expect(dbq.rows(@trans_table1)).to be == 0
    end
  end

end
