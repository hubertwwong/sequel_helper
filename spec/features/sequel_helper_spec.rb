require_relative "../../lib/sequel_helper"

describe SequelHelper do

  # testing some stuff out with sequel... can ignore this.
  describe "RAW" do
    before(:each) do
      @db_cred = {
        :adapter => "mysql2",
        :host => "localhost",
        :database => "space_ship",
        :user => "root",
        :password => "password"
      }
      @db_table_name = "fleet"
    end
    
    describe ".all test" do
      it "returns an array" do
        sq = SequelHelper.new @db_cred
        result = sq.client.from(:fleet).all
        expect(result.instance_of?(Array)).to eq(true)
      end
      
      it "1st item is a hash" do
        sq = SequelHelper.new @db_cred
        result = sq.client.from(:fleet).all
        expect(result[0].instance_of?(Hash)).to eq(true)
      end
    end
  end

  describe "QUERY" do
    before(:each) do
      @db_cred = {
        :adapter => "mysql2",
        :host => "localhost",
        :database => "space_ship",
        :user => "root",
        :password => "password"
      }
      @db_table_name = "fleet"
    end
    
    describe "row_exist?" do
      it "foo should eq false" do
        sq = SequelHelper.new @db_cred
        expect(sq.row_exist?("fleet", :name => "foo")).to eq(false)
      end
      
      it "name2 should eq true" do
        sq = SequelHelper.new @db_cred
        expect(sq.row_exist?("fleet", :name => "name2")).to eq(true)
      end
    end
  end

  describe "hello" do
    before(:each) do
      @db_cred = {
        :adapter => "mysql2",
        :host => "localhost",
        :database => "space_ship",
        :user => "root",
        :password => "password"
      }
    end
    
    it "should return hello" do
      ms = SequelHelper.new @db_cred
      expect(ms.hello).to eq('hello')
    end
  end
  
end