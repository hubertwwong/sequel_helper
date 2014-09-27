require "pathname"

require_relative "../../../../lib/sequel_helper/main/db_import"
require_relative "../../../../lib/sequel_helper/util/log_factory"
require_relative "../../../../lib/sequel_helper/main/yaml_config_loader"

describe DBImport do

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
      @orig_table = :orig_table22
      @col_name1 = :name1
      @col_start_date = :start_date

      # db init.
      @dbi = DBImport.new(db_params)

      # delete tables.
      begin
        @dbi.client.drop_table @orig_table
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

    describe "import_csv_lite_date" do
      it "basic" do
        csv_params = {:filename => file_fleet_csv,
                    :line_term_by => "\r\n",
                    :col_names => ["@dummy", "name", "description"]}

        params = {:csv_params => csv_params,
                  :table_name => "fleet",
                  :table_cols => ["name", "description"],
                  :key_cols => ["name"]}
        
        expect(@dbi.import_csv_lite_date(params)).to be == true
      end
    end
  end
  
end
