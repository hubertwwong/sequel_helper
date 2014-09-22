require "pathname"

require_relative "../../../../lib/sequel_helper/main/db_load_data"
require_relative "../../../../lib/sequel_helper/util/log_factory"
require_relative "../../../../lib/sequel_helper/main/yaml_config_loader"

describe DBLoadData do

  let(:db_params) {
      ycl = YAMLConfigLoader.new
      ycl.db_con_params
    }
  let(:file_fleet_csv) {
      Pathname.pwd.to_s + "/spec/fixtures/csv/fleet.csv"
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
      @orig_table = :load_data
      @col_name = :name
      @col_description = :description

      # db init.
      @dbld = DBLoadData.new(db_params)

      # delete tables.
      begin
        @dbld.client.drop_table @orig_table
      rescue Sequel::Error => e
        @log.debug e
      end

      # create a table
      # table creation need symbols for col names.
      # can't use instance variables for some reason.
      begin
        @dbld.client.create_table @orig_table do
          primary_key :id
          String :name
          String :description
        end
      rescue Sequel::Error => e
        @log.debug e
      end
    end

    describe "load_data" do
      it "basic" do
        params = {:filename => file_fleet_csv,
                :table_name => "load_data",
                :line_term_by => "\r\n",
                :col_names => ["@dummy", "name", "description"]}
        result = @dbld.load_data params
        
        expect(result).to be == true
      end
    end
  end

end