require_relative "../../../../../lib/sequel_helper/benchmark/insert/csv_insert"

require 'benchmark'
require 'bigdecimal/math'

describe CSVInsert do

  # basically run this once...
  describe "setup" do
    before(:each) do
      @n_times = 100000
        @db_params = {:adapter => "mysql2",
              :host => "localhost",
              :database => "benchmark_one",
              :user => "root",
              :password => "password"}
        @ci = CSVInsert.new @db_params
    end

    xit "db setup" do
      Benchmark.bm do |bm|
        bm.report('>db setup') do
          @ci.drop_table
          @ci.create_table
          @ci.insert_rows(@n_times)
        end
      end
    end
  end

  describe "csv import v1" do

  end



end

