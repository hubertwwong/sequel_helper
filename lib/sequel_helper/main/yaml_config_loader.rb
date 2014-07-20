require_relative '../util/yaml_util'

# moving all YAML config files into this file.
#
class YAMLConfigLoader

  attr_accessor :db_prefs, :dir_prefs, :gem_prefs

  def initialize
    @db_filename = 'config/database.yml'
    @dir_filename = 'config/dir_names.yml'
    @gem_filename = 'config/gem.yml'

    # load the yaml file.
    @db_prefs = YamlUtil.read(@db_filename)
    @dir_prefs = YamlUtil.read(@dir_filename)
    @gem_prefs = YamlUtil.read(@gem_filename)
  end

end
