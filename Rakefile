#require 'rspec/core/rake_task'
# used to load yml files for the project
require_relative 'lib/sequel_helper/main/yaml_config_loader'

# change this for default task when you run bundle exec rake
task :default => ['test:main']

# change this for task when you run run bundle exec rake all
# broken
#task :all => ['temp:foo']

namespace :run do

  # builds the gem and just figures out if it works in a really quick manner.
  # BROKEN....
  task :gem_smoke_test do
    require 'sequel_helper'

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
    puts ">> fleet. select all"
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
  end

end


namespace :build do

  task :gem do
    # read the file.
    ycl = YAMLConfigLoader.new
    
    gem_name = "sequel_helper"
    gem_spec_name = "sequel_helper.gemspec"
    gem_name_ver = "sequel_helper-" + ycl.gem_prefs["version"] + ".gem"
      
    puts "> uninstalling gem"
    system "gem uninstall " + gem_name  
      
    puts "> building gem"
    system "gem build " + gem_spec_name

    puts "> installing gem"
    system "gem install  " + gem_name
      
    puts "> deleting gem."
    system "rm " + gem_name_ver
  end

end



# runs rake something...
#
# put in a env variable to control what db its hits.
namespace :test do

  task :main do
    # set the env variable.
    # for now, its just a db switch statement.
    # for the name of the db to access.
    ENV['STOCK_SCRAPER_ENV'] = "test"
    puts ENV['STOCK_SCRAPER_ENV']

    # runs rspec. need to fix this at some point to use the db.
    system "bundle exec rspec"
    #puts "done"
  end

end

# db migrate...
#
# seems like its doind a redux..
namespace :db do

  task :migrate do
    # read the file.
    ycl = YAMLConfigLoader.new

    # fix this at some point.
    # fix what??
    ENV['STOCK_SCRAPER_ENV'] = "test"
    #puts ENV['STOCK_SCRAPER_ENV']

    # env variable.
    db_name = nil
    if ENV['STOCK_SCRAPER_ENV'] == "prod"
      db_name = ycl.db_prefs['db_name_prod']
    elsif ENV['STOCK_SCRAPER_ENV'] == "dev"
      db_name = ycl.db_prefs['db_name_dev']
    else # assume test
      db_name = ycl.db_prefs['db_name_test']
    end

    # build the command...
    puts "> db:migrate > " + ENV['STOCK_SCRAPER_ENV']
    puts ycl.db_prefs['db_user']

    # build the command to run.
    cmd = "sequel -m lib/sequel_helper/db/migration %s://%s:%s@%s/%s" %
      [
        ycl.db_prefs['db_adapter'],
        ycl.db_prefs['db_user'],
        ycl.db_prefs['db_password'],
        ycl.db_prefs['db_url'],
        db_name
      ]

    # runs migration. need to fix this at some point to use the db.
    puts cmd
    system cmd
  end

end

# stuck onn this...
# probably a better way
#
#desc "Run the specs."
#RSpec::Core::RakeTask.new(:spec)
#RSpec::Core::RakeTask.new do |t|
#  t.pattern = "spec/**/*_spec.rb"
#end
#
# URLS
# http://stackoverflow.com/questions/15168086/how-to-create-an-rspec-rake-task-using-rspeccoreraketask
# https://www.relishapp.com/rspec/rspec-core/docs/command-line/rake-task

# delete or ignore this.
# just testing to see how rake env works.
namespace :temp do

  task :foo do
    # can only pass env as strings.
    ENV["COFFEE_CUPS"] = "1"
    cups = ENV["COFFEE_CUPS"]
    require_relative 'temp/foo'
    include Foo
    Foo.hello
  end


  # if you want to have multiple build env based off a variable
  #task :build do |t, args|
  #  puts "Current env is #{ENV['RAKE_ENV']}"
  #end

end