require_relative "../../../../lib/sequel_helper/util/log_factory"

describe LogFactory do

  describe "main" do
    it "basic" do
      lf = LogFactory.build
      lf2 = LogFactory.build
      #lf2.debug "new site232"
      expect(lf).not_to be == nil
    end
  end

end
