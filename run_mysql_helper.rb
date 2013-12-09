require 'mysql2_helper'

# testing out to see if the gem was built correctly.

ms = Mysql2Helper.new
puts ms.hello

# testing the import..
@params = {:url => "localhost", :user => "root", 
                  :password => "password", :db_name => "space_ship",
                  :table_name => "fleet", :filename => "/home/user/fleet.csv"}
@db = Mysql2Helper.new(@params)

@db_params = {:concurrent_flag => true,
              :replace_flag => true,
              :fields_term_by => "\t",
              :line_term_by => "\r\n",
              :skip_num_lines => 1,
              :col_names => "@dummy, name, description"}
result = @db.load_data(@db_params)