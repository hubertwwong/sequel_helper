require 'sequel_helper', :git => "git://github.com/hubertwwong/sequel_helper.git"

# testing out to see if the gem was built correctly.
db_cred = {:adapter => "mysql2",
            :host => "localhost",
            :database => "space_ship",
            :user => "root",
            :password => "password"}

ms = SequelHelper.new db_cred
puts ms.hello
      
csv_params = {:filename => "/home/user/fleet.csv",
              :line_term_by => "\r\n",
              :col_names => ["@dummy", "name", "description"]}
                         
params = {:csv_params => csv_params,
          :table_name => "fleet",
          :table_cols => ["name", "description"],
          :key_cols => ["name"]}

# import csv.
result = ms.import_csv params