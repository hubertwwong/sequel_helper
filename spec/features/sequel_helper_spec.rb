require_relative "../../lib/sequel_helper"

describe SequelHelper do

  describe "hello" do
    it "should return hello" do
      ms = SequelHelper.new
      expect(ms.hello).to eq('hello')
    end
  end
  
end