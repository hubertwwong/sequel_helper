require_relative "../../../../lib/sequel_helper/util/logging"

describe "logging2" do
  include Logging

  it "log test" do
    logger.debug "test with no require"
    expect(true).to be == true
  end
end
