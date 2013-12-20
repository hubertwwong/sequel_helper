require_relative "../../../../lib/sequel_helper/gen/gen_insert"

describe GenInsert do
  
  describe "insert_select" do
    it "basic" do
      params = {:table_name => "fleet",
                :into_flag => true,
                :table_cols => ["date", "symbol", "open", "high", "low", "close", "adj_close", "volume"],
                :select_stmt =>
                      "f.date, f.symbol, f.open, f.high, f.low, f.close, f.adj_close, f.volume" +
                      " FROM foo f LEFT JOIN bar b" +
                      " ON f.date=b.date AND f.symbol=b.symbol" +
                      " WHERE b.symbol IS NULL"
                }
      final_str = "INSERT INTO fleet (date, symbol, open, high, low, close, adj_close, volume)" +
      " SELECT f.date, f.symbol, f.open, f.high, f.low, f.close, f.adj_close, f.volume" +
      " FROM foo f LEFT JOIN bar b" +
      " ON f.date=b.date AND f.symbol=b.symbol" +
      " WHERE b.symbol IS NULL;"
      
      result = GenInsert.insert_select params
      expect(result).to eq(final_str)
    end
  end
  
end
