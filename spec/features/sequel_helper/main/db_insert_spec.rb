require_relative "../../../../lib/sequel_helper/main/db_insert"
require_relative "../../../../lib/sequel_helper/main/yaml_config_loader"
require_relative "../../../../lib/sequel_helper/util/log_factory"

describe DBInsert do

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
      @orig_table = "orig_table22"
      @insert_table = "insert_update22"
      @col_name1 = "name1"
      @row_val_foo = "foo"
      @row_val_bar = "bar"
      @row_val_baz = "baz"

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
          primary_key "id"
          String "name1"
        end
        @dbi.client.create_table @insert_table do
          primary_key "id"
          String "name1"
        end
      rescue Sequel::Error => e
        @log.debug e
      end

      #@log.debug @orig_table
      #@log.debug @col_name1
      #@log.debug @roe_val_foo
      #@log.debug @roe_val_bar

      # insert some table in orig table...
      @dbi.client[@orig_table.to_sym].insert([@col_name1], [@row_val_foo])
      @dbi.client[@orig_table.to_sym].insert([@col_name1], [@row_val_bar])

      # insert stuff into the new table
      @dbi.client[@insert_table.to_sym].insert([@col_name1], [@row_val_baz])
    end

    describe "connect" do
      xit "basic" do
        dbq = DBInsert.new(db_params)
        expect(dbq.client.test_connection).to be == true
      end
    end

    describe "insert_select" do
      it "basic" do
        table_name = @insert_table
        table_cols = [@col_name1]
        select_stmt = "o.name1" +
                      " FROM orig_table22 o LEFT JOIN insert_update22 i" +
                      " ON i.id=o.id"
        insert_params = {table_name: table_name,
                         table_cols: table_cols,
                         select_stmt: select_stmt}

        expect(@dbi.insert_select(insert_params)).to be == true
      end
    end
  end

end
