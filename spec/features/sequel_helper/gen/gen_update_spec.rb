require_relative "../../../../lib/sequel_helper/gen/gen_update"
require_relative "../../../../lib/sequel_helper/gen/gen_string"

describe GenUpdate do
  
  describe "update" do
    it "basic" do
      params = {:table_ref => "space_ship",
                :set_ref => "bar"}
      final_str = "UPDATE space_ship SET bar;"
      
      result = GenUpdate.update params
      expect(result).to eq(final_str)
    end
    
    it "using arrays_to_str" do
      set_params = {:array_vals1 => ["foo", "bar", "baz"],
                    :seperator1 => "|",
                    :suffix1 => ".chu",
                    :open_by => "[",
                    :closed_by => "]"}
      set_str = GenString.arrays_to_str set_params                    
      params = {:table_ref => "space_ship",
                :set_ref => set_str}
      final_str = "UPDATE space_ship SET [foo.chu|bar.chu|baz.chu];"
      
      result = GenUpdate.update params
      expect(result).to eq(final_str)
    end
  end
  
end
