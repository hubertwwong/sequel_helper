require_relative "../../../../lib/sequel_helper/main/db_query"

describe DBQuery do
    
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
    
    xit "connect" do
      c = DBQuery.new(db_param)
      result = c.connect
      expect(result.test_connection).to be == true
    end
      
    xit "connect and disconnect" do
      c = DBQuery.new(db_param)
      result = c.connect
      expect(result.test_connection).to be == true
      
      result = c.disconnect
      expect(result.test_connection).to be == false
    end
  end
  
end