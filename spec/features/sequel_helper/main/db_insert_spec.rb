require_relative "../../../../lib/sequel_helper/main/db_insert"
require_relative "../../../../lib/sequel_helper/main/yaml_config_loader"
#require_relative "../../../../lib/sequel_helper/main/client_helper"

describe DBInsert do

  describe "main" do
    let(:db_params) {
        ycl = YAMLConfigLoader.new
        ycl.db_con_params
      }

    before(:each) do
      # table name
      @orig_table = "orig_table"
      @insert_table = "insert_update"
      @col_name1 = "name1"
      @row1_val = "bar"
      @row2_val = "foo"

      # db init.
      @dbi = DBInsert.new(db_params)

      # delete tables.
      begin
        @dbi.client.drop_table @orig_table
        @dbi.client.drop_table @insert_table
      rescue Sequel::Error => e
        puts e
      end

      # create a table
      # table creation need symbols for col names.
      # can't use instance variables for some reason.
      begin
        @dbi.client.create_table @orig_table do
          primary_key :id
          String :name1
        end
        @dbi.client.create_table @insert_table do
          primary_key :id
          String :name1
        end
      rescue Sequel::Error => e
        puts e
      end

      # insert some table in orig table...
      @dbi.client[@orig_table].insert([@col_name1], [@row1_val])
      @dbi.client[@orig_table].insert([@col_name1], [@row2_val])
    end

    describe "connect" do
      it "basic" do
        dbq = DBInsert.new(db_params)
        expect(dbq.client.test_connection).to be == true
      end
    end

    describe "insert_select" do
      it "basic" do
        table_name = @orig_table
        table_cols = [@col_name1]
        select_stmt = "o.name" +
                      " FROM orig_table o LEFT JOIN insert_update i" +
                      " ON f.id=i.id"
        insert_params = {table_name: table_name,
                         table_cols: table_cols,
                         select_stmt: select_stmt}

        expect(@dbi.insert_select(insert_params)).to be == true
      end
    end
  end

end
