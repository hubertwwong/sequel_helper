require_relative "../../lib/sequel_helper"

describe SequelHelper do

  describe "LOAD_DATA" do
    before(:each) do
      @db_cred = {
        :adapter => "mysql2",
        :host => "localhost",
        :database => "space_ship",
        :user => "root",
        :password => "password"
      }
    end
    
    describe "load_data" do
      before(:each) do
        @load_param = {:filename => "/home/user/fleet.csv",
                :table_name => "new_fleet",
                :line_term_by => "\r\n",
                :col_names => ["@dummy", "name", "description"]}
      end
      
      xit "basic" do
        sq = SequelHelper.new @db_cred
        expect(sq.load_data(@load_param)).to eq(true)
      end
    end
  end

  describe "TABLE" do
    before(:each) do
      @db_cred = {
        :adapter => "mysql2",
        :host => "localhost",
        :database => "space_ship",
        :user => "root",
        :password => "password"
      }
    end
    
    describe "clone_table" do
      xit "basic" do
        sq = SequelHelper.new @db_cred
        expect(sq.clone_table("fleet", "new_fleet")).to eq(false)
      end
    end
    
    describe "drop" do
      xit "basic" do
        sq = SequelHelper.new @db_cred
        expect(sq.client.drop_table("new_fleet")).to eq(false)
      end
    end
  end

  
  # testing some stuff out with sequel... can ignore this.
  describe "SELECT" do
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

  describe "INSERT" do
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
    
    describe "insert_unique" do
      it "false case" do
        sq = SequelHelper.new @db_cred
        insert_param = {:name => "name2", :description => "description2"}
        
        expect(sq.insert_unique(@db_table_name, insert_param)).to eq(false)
      end
      
      it "true case" do
        sq = SequelHelper.new @db_cred
        insert_param = {:name => "name" + Random.rand(999999999999).to_s, 
                        :description => "description" + Random.rand(999999999999).to_s}
                        
        expect(sq.insert_unique(@db_table_name, insert_param)).to eq(true)
      end
    end
  end
  
  describe "CSVIMPORT" do
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
    
    it "basic" do
      sq = SequelHelper.new @db_cred
      params = {:filename => "/user/home/fleet.csv",
                :table_name => "fleet",
                :table_cols => ["name", "description"],
                :key_cols => ["name"]}
      
      expect(sq.import_csv(params)).to eq(true)
    end
  end  

  describe "MISC QUERY" do
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
        expect(sq.row_exist?("fleet", :name => "foo")).to eq(true)
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