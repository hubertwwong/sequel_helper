require "pathname"

require_relative "../../../../lib/sequel_helper/gen/gen_load_data"

describe GenLoadData do
  
  describe "create" do
    let(:file_fleet_csv) {
        Pathname.pwd.to_s + "/spec/fixtures/csv/fleet.csv"
      }
    
    it "basic" do
      params = {:filename => file_fleet_csv,
                :table_name => "space_ship",
                :line_term_by => "\r\n",
                :col_names => ["@dummy", "name", "description"]}
      final_str = "LOAD DATA INFILE '#{file_fleet_csv}' INTO TABLE space_ship LINES TERMINATED BY '\r\n' (@dummy, name, description);"
      
      result = GenLoadData.load_data params
      expect(result).to eq(final_str)
    end
    
    it "full" do
      params = {:filename => file_fleet_csv,
                :concurrent_flag => true,
                :replace_flag => true,
                :table_name => "space_ship",
                :fields_term_by => "\t",
                :fields_enclosed_by => "\"",
                :line_term_by => "\r\n",
                :skip_num_lines => 1,
                :col_names => ["@dummy", "name", "description"]}
      final_str = "LOAD DATA CONCURRENT INFILE '#{file_fleet_csv}' REPLACE INTO TABLE space_ship FIELDS TERMINATED BY '\t' ENCLOSED BY '\"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES (@dummy, name, description);"
      
      result = GenLoadData.load_data params
      expect(result).to eq(final_str)
    end
    
    it "full v2" do
      params = {:filename => file_fleet_csv,
                :concurrent_flag => true,
                :replace_flag => true,
                :table_name => "space_ship",
                :fields_term_by => "\t",
                :fields_enclosed_by => "\"",
                :line_term_by => "\r\n",
                :skip_num_lines => 1,
                :col_names => ["@dummy", "name", "description"],
                :set_col_names => ["column2='dummy'"]}
      final_str = "LOAD DATA CONCURRENT INFILE '#{file_fleet_csv}' REPLACE INTO TABLE space_ship FIELDS TERMINATED BY '\t' ENCLOSED BY '\"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES (@dummy, name, description) SET column2='dummy';"
      
      result = GenLoadData.load_data params
      expect(result).to eq(final_str)
    end
  end
  
end