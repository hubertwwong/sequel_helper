require_relative "../../../../lib/sequel_helper/main/sequel_factory"

describe SequelFactory do

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

    describe "connect" do
      it "basic" do
        sf = SequelFactory.new(db_params)
        result = sf.connect
        expect(result.test_connection).to be == true
      end
    end

    describe "connect_test_db" do
      it "basic" do
        result = SequelFactory.connect_test_db
        expect(result.test_connection).to be == true
      end

      it "connect and disconnect" do
        c = SequelFactory.connect_test_db
        expect(c.test_connection).to be == true

        # disconnecting.
        result = c.disconnect
        expect(c.test_connection).to be == false
      end
    end
  end

end
