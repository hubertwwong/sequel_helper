require 'sequel_helper'

@db_params = {:adapter => "mysql2",
            :host => "localhost",
            :database => "stock4_development",
            :user => "root",
            :password => "password"}

@col_names = ["price_date", "open", "high", "low", "close", "volume", 
                  "adj_close"]

# need symbol...    
@table_cols = ["price_date", "open", "high", "low", "close", "volume", 
               "adj_close", "stock_symbol_id"]

# this was wrong...
# not matching the params.
@key_cols = ["price_date", "stock_symbol_id"]

# character encodin was wrong too..
# skip line num param was wrong...
# wording backwards                  
@csv_params = {:filename => nil,
               :line_term_by => "\n",
               :fields_term_by => ",",
               :skip_num_lines => 1,
               :local_flag => true,
               :col_names => @col_names,
               :set_col_names => nil}
                     
@import_csv_params = {:csv_params => @csv_params,
                      :table_name => "stock_quotes",
                      :table_cols => @table_cols,
                      :key_cols => @key_cols}
                      
@csv_params[:filename] = "/home/user/zzz/vmsync/data/.stock_scraper/csv/stock_quotes/42765.csv"
@csv_params[:set_col_names] = ["stock_symbol_id='42765'"]

@import_csv_params[:csv_params] = @csv_params
puts @import_csv_params.to_s

@sequel_helper = SequelHelper.new @db_params
@sequel_helper.import_csv @import_csv_params