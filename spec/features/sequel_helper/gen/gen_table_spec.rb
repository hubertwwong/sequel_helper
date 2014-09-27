require_relative "../../../../lib/sequel_helper/gen/gen_table"

describe GenTable do

  describe "clone" do
    it "basic" do
      result = GenTable.clone("foo", "foo_clone")
      expect(result).to be == "CREATE TABLE foo_clone LIKE foo;"
    end
  end

end
