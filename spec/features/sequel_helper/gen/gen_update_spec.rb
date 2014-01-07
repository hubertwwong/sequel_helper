require_relative "../../../../lib/sequel_helper/gen/gen_update"

describe GenUpdate do
  
  describe "update" do
    it "basic" do
      params = {:table_ref => "space_ship",
                :set_ref => "bar"}
      final_str = "LOAD DATA INFILE '/home/user/fleet.csv' INTO TABLE space_ship LINES TERMINATED BY '\r\n' (@dummy, name, description);"
      
      result = GenUpdate.update params
      expect(result).to eq(final_str)
    end
  end
  
end
