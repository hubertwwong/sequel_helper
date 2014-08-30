require_relative "../../../../lib/sequel_helper/gen/gen_select"

# remove the code here. add the actual gen_select.
describe GenSelect do

  describe "select" do
    xit "self select" do
      GenSelect.select
      expect(result).to eq(nil)
    end

    xit "select2" do
      gs = GenSelect.new
      gs.select2
      expect(gs).to eq(nil)
    end
  end

end
