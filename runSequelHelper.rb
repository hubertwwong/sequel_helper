require 'sequel_helper'

# testing out to see if the gem was built correctly.
db_cred = {:adapter => "mysql2",
            :host => "localhost",
            :database => "space_ship",
            :user => "root",
            :password => "password"}

puts "> init >>>>>>>>>>>>"
ms = SequelHelper.new db_cred

# logger...
puts "logger attached"
ms.client.sql_log_level = :debug
ms.client.loggers << Logger.new($stdout)

# testing out the use of client...
puts "select all"
ms.client[:fleet].all

puts "> import_csv >>>>>>>>>>>"      
csv_params = {:filename => "/home/user/fleet.csv",
              :line_term_by => "\r\n",
              :col_names => ["@dummy", "name", "description"]}
                         
params = {:csv_params => csv_params,
          :table_name => "fleet",
          :table_cols => ["name", "description"],
          :key_cols => ["name"]}

# import csv.
result = ms.import_csv params