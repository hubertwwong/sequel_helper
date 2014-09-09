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

  describe "import from tables" do
    before(:each) do
      # table name
      @import_src = :import_src
      @import_dest = :import_dest

      # delete tables.
      begin
        @db.drop_table @import_src
        @db.drop_table @import_dest
      rescue Sequel::Error => e
        @log.debug e
      end

      # create table
      begin
        @db.create_table @import_src do
          primary_key :id
          String :name1
          DateTime :start_date
        end

        @db.create_table @import_dest do
          primary_key :id
          String :name1
          DateTime :start_date
        end
      rescue Sequel::Error => e
        @log.debug e
      end

      # insert src table....
      @db.transaction do
        (0..100).each do |i|
          {}
          @db[@import_src].insert(name1: "foo" + i.to_s,
                                    start_date: (Date.today - i))
        end
      end
    end

    it "load 20" do
      rows = 0
      @db.transaction do
        # copy from src to dest.
        @db[@import_dest].import([:name1, :start_date],
                 @db[@import_src].select(:name1, :start_date).where{start_date > (Date.today - 19)})

        # select dest...
        rows = @db[@import_dest]
      end
      expect(rows.count).to be == 19
    end

    # stuck on this...
    # just break out manually..
    xit "where specific day" do
      expect(@db[@import_src].where(start_date: (Date.today - 90)).count).to be == 1
    end

    xit "where range" do
      rows = @db[@import_src].where(start_date: (Date.today - 34)..(Date.today - 30))
      expect(rows.count).to be == 5
    end

    xit "date recent first" do
      row = @db[@import_src].reverse_order(:start_date).first
      expect(row[:start_date]).to be > (Time.now - 60*60*24)
      expect(row[:start_date]).to be < (Time.now + 60*60*24)
    end

    xit "date oldest first" do
      expect(@db[@import_src].order(:start_date)).to be < Time.now
    end
  end

end
