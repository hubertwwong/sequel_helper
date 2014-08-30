require_relative "../util/logging"
require_relative "../util/log_factory"
#
# might wanna skip it for now...
#
class GenSelect

  #include Logging
  
  def self.select
    l = LogFactory.build
    l.debug "self.select4"
    #logger.debug "self.select"
  end

  def select2
    l = LogFactory.build
    l.debug "self.select3"
    #logger.debug "self.select2"
  end

end
