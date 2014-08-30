require_relative "../main/yaml_config_loader"

module Logging
  # This is the magical bit that gets mixed into your classes
  def logger
    Logging.logger
  end

  # Global, memoized, lazy initialized instance of a logger
  def self.logger
    ycl = YAMLConfigLoader.new
    lf = ycl.main_prefs["log_file"]
    @logger ||= Logger.new(lf)
  end

  # to use this...
  # include Logging
  #
  # logger.something to call it...
  #
  # http://stackoverflow.com/questions/917566/ruby-share-logger-instance-among-module-classes
end
