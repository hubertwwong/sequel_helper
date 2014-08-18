require_relative "../../../../lib/sequel_helper/main/client_helper"

describe ClientHelper do
  
  describe "main" do
    let(:db_param) {
        {
          adapter: "mysql2",
          host: "localhost",
          database: "sequel_helper_test",
          user: "root",
          password: "password"
        }
      }
    
    it "connect" do
      c = ClientHelper.new(db_param)
      result = c.connect
      expect(result.test_connection).to be == true
    end
      
    it "connect and disconnect" do
      c = ClientHelper.new(db_param)
      result = c.connect
      expect(result.test_connection).to be == true
      
      # how to test this...
      result = c.disconnect
      expect(result).not_to be == nil
    end
  end
  
end