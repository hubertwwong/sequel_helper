require_relative "../../../../lib/sequel_helper/main/db_query"
require_relative "../../../../lib/sequel_helper/main/yaml_config_loader"
#require_relative "../../../../lib/sequel_helper/main/client_helper"

describe DBQuery do

  describe "main" do
    let(:db_params) {
        ycl = YAMLConfigLoader.new
        ycl.db_con_params
      }

    before(:each) do
      # table name
      @row_exist_table = :row_exist
      @col_name1 = :name1
      @row1_val = "bar"
      @row2_val = "foo"

      # db init.
      @dbq = DBQuery.new(db_params)

      # delete tables.
      begin
        @dbq.client.drop_table @row_exist_table
      rescue Sequel::Error => e
        puts e
      end

      # create a table
      # table creation need symbols for col names.
      # can't use instance variables for some reason.
      begin
        @dbq.client.create_table @row_exist_table do
          primary_key :id
          String :name1
        end
      rescue Sequel::Error => e
        puts e
      end

      # insert some rows...
      @dbq.client[@row_exist_table].insert([@col_name1], [@row1_val])
      @dbq.client[@row_exist_table].insert([@col_name1], [@row2_val])
    end

    describe "connect" do
      it "basic" do
        dbq = DBQuery.new(db_params)
        expect(dbq.client.test_connection).to be == true
      end
    end

    describe "row_exist?" do
      it "basic" do
        expect(@dbq.row_exist?(@row_exist_table)).to be == true
      end

      it "where" do
        expect(@dbq.row_exist?(@row_exist_table, "name1='foo'")).to be == true
      end
    end

    describe "rows" do
      it "basic" do
        dbq = DBQuery.new(db_params)
        expect(dbq.rows(@row_exist_table)).to be == 2
      end
    end
  end

end
