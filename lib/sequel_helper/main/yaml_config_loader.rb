require_relative '../util/yaml_util'

# moving all YAML config files into this file.
#
class YAMLConfigLoader

  attr_accessor :db_prefs, :dir_prefs, :gem_prefs, :main_prefs

  def initialize
    @db_filename = 'config/database.yml'
    @dir_filename = 'config/dir_names.yml'
    @gem_filename = 'config/gem.yml'
    @env_filename = "config/env.yml"
    @main_filename = "config/main.yml"

    # load the yaml file.
    @db_prefs = YamlUtil.read(@db_filename)
    @dir_prefs = YamlUtil.read(@dir_filename)
    @gem_prefs = YamlUtil.read(@gem_filename)
    @env_prefs = YamlUtil.read(@env_filename)
    @main_prefs = YamlUtil.read(@main_filename)
  end

  # use this to pass params to sequel connect.
  # pulls from the envs variables.
  # should be used internally by gem and not externally.
  def db_con_params
    db_name = nil

    # check env
    if @env_prefs["env"] == "test"
      db_name = @db_prefs["db_name_test"]
    elsif @env_prefs["env"] == "dev"
      db_name = @db_prefs["db_name_dev"]
    elsif @env_prefs["env"] == "prod"
      db_name = @db_prefs["db_name_prod"]
    end

    db_params = {
      :adapter => @db_prefs["db_adapter"],
      :host => @db_prefs["db_url"],
      :database => db_name,
      :user => @db_prefs["db_user"],
      :password => @db_prefs["db_password"]
    }

    return db_params
  end

end
