require_relative "../../../lib/gen/gen_string"

describe GenString do
  
  describe "conditional" do
    describe "append_not_nil" do
      it "nil nil" do
        result = GenString.append_not_nil(nil, nil)
        expect(result).to eq(nil)
      end
      
      it "nil str" do
        result = GenString.append_not_nil(nil, "foo")
        expect(result).to eq(nil)
      end
      
      it "str nil" do
        result = GenString.append_not_nil("foo", nil)
        expect(result).to eq("foo")
      end
      
      it "str str" do
        result = GenString.append_not_nil("foo", "foo")
        expect(result).to eq("foofoo")
      end
    end
    
    describe "bool_first" do
      it "nil" do
        params = nil
        result = GenString.bool_first(params)
        expect(result).to eq(nil)
      end
      
      it "foo" do
        params = "foo"
        result = GenString.bool_first(params)
        expect(result).to eq(nil)
      end
      
      it "[[true,foo]]" do
        params = [[true, "foo"]]
        result = GenString.bool_first(params)
        expect(result).to eq("foo")
      end
      
      it "[[false ,foo]]" do
        params = [[false, "foo"]]
        result = GenString.bool_first(params)
        expect(result).to eq(nil)
      end
      
      it "[[false ,foo], [true ,foo]]" do
        params = [[false, "foo"], [true, "bar"]]
        result = GenString.bool_first(params)
        expect(result).to eq("bar")
      end
      
      it "[[gahsf ,foo]]" do
        params = [["gahsf", "foo"]]
        result = GenString.bool_first(params)
        expect(result).to eq(nil)
      end
      
      it "[[nil ,foo]]" do
        params = [[nil, "foo"]]
        result = GenString.bool_first(params)
        expect(result).to eq(nil)
      end
    end
  end
  
  describe "enclose" do
    describe "enclose_with_paren" do
      it "nil" do
        params = nil
        result = GenString.enclose_with_paren(params)
        expect(result).to eq(nil)
      end
      
      it "foo" do
        params = "foo"
        result = GenString.enclose_with_paren(params)
        expect(result).to eq("\(foo\)")
      end
    end
    
    describe "enclose_with_single_quote" do
      it "nil" do
        params = nil
        result = GenString.enclose_with_single_quote(params)
        expect(result).to eq(nil)
      end
      
      it "foo" do
        params = "foo"
        result = GenString.enclose_with_single_quote(params)
        expect(result).to eq("'foo'")
      end
    end
  end
  
  describe "array to string" do
    describe "array_to_comma_str" do
      it "nil" do
        params = nil
        result = GenString.array_to_comma_str(params)
        expect(result).to eq(nil)
      end
      
      it "foo" do
        params = ["foo"]
        result = GenString.array_to_comma_str(params)
        expect(result).to eq("foo")
      end
      
      it "foo bar baz" do
        params = ["foo", "bar", "baz"]
        result = GenString.array_to_comma_str(params)
        expect(result).to eq("foo, bar, baz")
      end
    end
  end
  
end