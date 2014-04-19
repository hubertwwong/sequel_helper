require_relative "../../../../../lib/sequel_helper/benchmark/insert/naive_insert"

require 'benchmark'
require 'bigdecimal/math'

describe NaiveInsert do
  
  describe "naive1" do
    
    before(:each) do
      @n_times = 1000
      @db_params = {:adapter => "mysql2",
            :host => "localhost",
            :database => "benchmark_one",
            :user => "root",
            :password => "password"}
      @ni = NaiveInsert.new @db_params
    end    
    
    it "naive1" do
      @ni.drop_table
          
      Benchmark.bm do |bm|
        bm.report('>naive1') do
          @ni.create_table1
          @ni.insert1(@n_times)
        end
      end
      
      z = false
      expect(z).to eq(true)
    end
    
    it "naive2" do
      @ni.drop_table
      
      Benchmark.bm do |bm|
        bm.report('>naive2') do
          @ni.create_table2
          @ni.insert2(@n_times)
        end
      end
      
      z = false
      expect(z).to eq(true)
    end
    
    it "naive3" do
      @ni.drop_table
      
      Benchmark.bm do |bm|
        bm.report('>naive3') do
          @ni.create_table3
          @ni.insert3(@n_times)
        end
      end
      
      z = false
      expect(z).to eq(true)
    end
    
    it "naive4" do
      @ni.drop_table
      
      Benchmark.bm do |bm|
        bm.report('>naive4') do
          @ni.create_table4
          @ni.insert4(@n_times)
        end
      end
      
      z = false
      expect(z).to eq(true)
    end
    
    it "naive5" do
      @ni.drop_table
      
      Benchmark.bm do |bm|
        bm.report('>naive5') do
          @ni.create_table5
          @ni.insert5(@n_times)
        end
      end
      
      z = false
      expect(z).to eq(true)
    end 
  end
  
end
