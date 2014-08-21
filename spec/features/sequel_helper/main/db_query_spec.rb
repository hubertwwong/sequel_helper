require_relative "../../../../lib/sequel_helper/main/db_query"
#require_relative "../../../../lib/sequel_helper/main/client_helper"

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

    it "connect" do
      c = DBQuery.new(db_param)
      result = c.client.connect
      expect(c.client.test_connection).to be == true
    end

    it "connect and disconnect" do
      c = DBQuery.new(db_param)
      result = c.client.connect
      expect(c.client.test_connection).to be == true

      result = c.client.disconnect
      expect(c.client.test_connection).to be == false
    end
  end

end
