require_relative 'main/yaml_config_loader'

module SequelHelper
  # LOAD YCL. Basically has all of the system settings.
  # want to load the version there instead of hard coding it here...
  ycl = YAMLConfigLoader.new
    
  VERSION = ycl.gem_prefs["version"]
end