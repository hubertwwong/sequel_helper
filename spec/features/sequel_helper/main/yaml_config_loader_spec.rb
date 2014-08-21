require_relative "../../../../lib/sequel_helper/main/yaml_config_loader"

describe YAMLConfigLoader do

  describe "main" do
    it "basic" do
      ycl = YAMLConfigLoader.new

      expect(ycl.gem_prefs["version"]).to eq("0.0.12")
    end

    it "db_con_params" do
      ycl = YAMLConfigLoader.new
      db_params = ycl.db_con_params
      expect(db_params[:adapter]).to eq("mysql2")
    end
  end

end
