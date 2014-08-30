require_relative "../../../../lib/sequel_helper/util/logging"

describe Logging do

  include Logging

  describe "main" do
    it "basic" do
      logger.debug "logging spec2"
      logger.debug "logging spec3"
      expect(true).not_to be == nil
    end
  end

end
