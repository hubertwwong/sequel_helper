require_relative "../../../../lib/sequel_helper/main/db_query"
#require_relative "../../../../lib/sequel_helper/main/client_helper"

describe DBQuery do

  describe "main" do
    let(:db_params) {
        {
          adapter: "mysql2",
          host: "localhost",
          database: "sequel_helper_test",
          user: "root",
          password: "password"
        }
      }

    it "connect" do
      dbq = DBQuery.new(db_params)
      expect(dbq.client.test_connection).to be == true
    end

    it "connect and disconnect" do
      dbq = DBQuery.new(db_params)
      expect(dbq.client.test_connection).to be == true

      result = dbq.client.disconnect
      #result = c.client.disconnect
      sleep 5
      expect(dbq.client.test_connection).to be == false
    end
  end

end
