require_relative "../../../../lib/sequel_helper/main/db_query"
require_relative "../../../../lib/sequel_helper/main/sequel_factory"
require_relative "../../../../lib/sequel_helper/main/yaml_config_loader"
require_relative "../../../../lib/sequel_helper/util/log_factory"

describe "Dates" do

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

  describe "dates dates dates" do
    before(:each) do
      # table name
      @dates_table1 = :dates_table

      # delete tables.
      begin
        @db.drop_table @dates_table1
      rescue Sequel::Error => e
        @log.debug e
      end

      # create a table
      begin
        @db.create_table @dates_table1 do
          primary_key :id
          String :name1
          DateTime :start_date
        end
      rescue Sequel::Error => e
        @log.debug e
      end

      # insert a few values...
      @db.transaction do
        (0..100).each do |i|
          {}
          @db[@dates_table1].insert(name1: "foo" + i.to_s,
                                    start_date: (Date.today - i))
        end
      end
    end
    
    # stuck on this...
    # just break out manually..
    it "where specific day" do
      expect(@db[@dates_table1].where(start_date: (Date.today - 90)).count).to be == 1
    end

    it "where range" do
      rows = @db[@dates_table1].where(start_date: (Date.today - 34)..(Date.today - 30))
      expect(rows.count).to be == 5
    end

    it "date recent first" do
      row = @db[@dates_table1].reverse_order(:start_date).first
      expect(row[:start_date]).to be > (Time.now - 60*60*24)
      expect(row[:start_date]).to be < (Time.now + 60*60*24)
    end

    it "date oldest first" do
      expect(@db[@dates_table1].order(:start_date)).to be < Time.now
    end
  end

end
