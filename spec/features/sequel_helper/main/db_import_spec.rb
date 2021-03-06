require "pathname"

require_relative "../../../../lib/sequel_helper/main/db_import"
require_relative "../../../../lib/sequel_helper/main/db_query"
require_relative "../../../../lib/sequel_helper/util/log_factory"
require_relative "../../../../lib/sequel_helper/main/yaml_config_loader"

describe DBImport do

  let(:table_name_orig)     {:import_22}
  let(:col_name_date)       {:date}
  let(:col_name_name)       {:name}
  let(:db_params) {
      ycl = YAMLConfigLoader.new
      ycl.db_con_params
    }
  let(:file_name_date) {
      Pathname.pwd.to_s + "/spec/fixtures/csv/nameDate.csv"
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
       # db init.
      @dbi = DBImport.new(db_params)
      @dbq = DBQuery.new(db_params)
      # delete tables.
      begin
        @dbi.client.drop_table table_name_orig
      rescue Sequel::Error => e
        @log.debug e
      end

      # create a table
      # table creation need symbols for col names.
      # can't use instance variables for some reason.
      begin
        @dbi.client.create_table table_name_orig do
          primary_key :id
          DateTime :date
          String :name
        end
      rescue Sequel::Error => e
        @log.debug e
      end

      # insert some table in orig table...
      @dbi.client[table_name_orig.to_sym].insert(
          [col_name_date, col_name_name], ["2014-09-21", "bartastic 1"])
      @dbi.client[table_name_orig.to_sym].insert(
          [col_name_date, col_name_name], ["2014-09-22", "bartastic 2"])
    end

    # need to fix this too.
    describe "import_csv_lite_date" do
      it "basic" do
        csv_params = {filename: file_name_date,
                      line_term_by: "\r\n",
                      col_names: [col_name_date, col_name_name],
                      skip_num_lines: 1,
                      fields_term_by: ","}

        result = @dbi.import_csv_lite_date csv_params: csv_params,
                                           table_name: table_name_orig,
                                           table_cols: [col_name_date, col_name_name],
                                           date_col_name: col_name_date,
                                           date_val: Date.parse("2014-09-25")
        
        # should be 3 rows. 2 from the init. 1 inserted.
        expect(@dbq.rows(table_name_orig)).to be == 3
      end
    end
  end
  
end