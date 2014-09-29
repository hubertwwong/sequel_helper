require_relative "../../../../lib/sequel_helper/main/db_table"
require_relative "../../../../lib/sequel_helper/main/yaml_config_loader"

describe DBTable do

  describe "main" do
    let(:table_name_orig)           {"orig_table"}
    let(:table_name_clone)          {"clone_table"}
    let(:table_name_orig_default)   {"orig_table_clone"}
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
        
        # delete tables.
        begin
          @dbt.client.drop_table table_name_orig
          @dbt.client.drop_table table_name_clone
          @dbt.client.drop_table table_name_orig_default
        rescue Sequel::Error => e
          puts e
        end

        # create a table
        begin
          @dbt.client.create_table table_name_orig do
            String :name
          end
        rescue Sequel::Error => e
          puts e
        end
      end

      it "basic" do
        # clone table
        @dbt.clone(table_name_orig, table_name_clone)

        # check if the cloned table exist.
        expect(@dbt.client.table_exists? table_name_clone).to be == true
      end
      
      it "default param" do
        # clone table
        @dbt.clone(table_name_orig)

        # check if the cloned table exist.
        expect(@dbt.client.table_exists? table_name_orig_default).to be == true
      end
    end
  end

end