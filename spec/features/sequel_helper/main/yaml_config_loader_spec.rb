require_relative "../../../../lib/sequel_helper/main/yaml_config_loader"

describe YAMLConfigLoader do
  
  describe "main" do
    it "basic" do
      ycl = YAMLConfigLoader.new
        
      expect(ycl.gem_prefs["version"]).to eq("0.0.12")
    end
  end
  
end
