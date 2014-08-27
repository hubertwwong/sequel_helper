require_relative "../../../../lib/sequel_helper/main/db_table"
require_relative "../../../../lib/sequel_helper/main/yaml_config_loader"

describe DBTable do

  describe "main" do
    let(:db_params) {
        ycl = YAMLConfigLoader.new
        ycl.db_con_params
      }

    describe "connect" do
      it "basic" do
        dbt = DBTable.new(db_params)
        expect(dbt.client.test_connection).to be == true
      end
    end

    describe "clone table" do
      before(:each) do
        @dbt = DBTable.new(db_params)
        @orig_table = "orig_table"
        @clone_table = "clone_table"

        # delete tables.
        begin
          @dbt.client.drop_table @orig_table
          @dbt.client.drop_table @clone_table
        rescue Sequel::Error => e
          puts e
        end

        # create a table
        begin
          @dbt.client.create_table @orig_table do
            String :name
          end
        rescue Sequel::Error => e
          puts e
        end
      end

      it "basic" do
        # clone table
        @dbt.clone_table(@orig_table, @clone_table)

        # check if the cloned table exist.
        expect(@dbt.client.table_exists? @clone_table).to be == true
      end
    end
  end

end
