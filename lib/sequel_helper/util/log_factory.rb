require_relative "../main/yaml_config_loader"

class LogFactory

  attr_accessor :log

  # return a log object
  def self.build
    if @log == nil
      ycl = YAMLConfigLoader.new
      lf = ycl.main_prefs["log_file"]
      @log = Logger.new(lf)
      return @log
    else
      return @log
    end
  end

end
