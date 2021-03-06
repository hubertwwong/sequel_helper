require_relative "../../../../lib/sequel_helper/gen/gen_string"

describe GenString do
  
  describe "conditional" do
    describe "append_not_nil" do
      it "nil nil" do
        result = GenString.append_not_nil(nil, nil, nil)
        
        expect(result).to eq(nil)
      end
      
      it "nil str" do
        result = GenString.append_not_nil(nil, "foo", "foo")
        
        expect(result).to eq(nil)
      end
      
      it "str nil" do
        result = GenString.append_not_nil("foo", nil, nil)
        
        expect(result).to eq("foo")
      end
      
      it "str str" do
        result = GenString.append_not_nil("foo", "foo", "foo")
        
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
    
    describe "append_if_true" do
      it "barbarbar fofofo" do
        main_str = "barbarbar"
        append_str = "fofofo"
        bool_value = true
        space_flag = true
        result = GenString.append_if_true(main_str, append_str, bool_value, space_flag)
        
        expect(result).to eq("barbarbar fofofo")
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
    
    describe "array_to_str" do
      it "foo, bar" do
        params = {:array_vals => ["foo", "bar"],
                  :seperator => ", "}
        result = GenString.array_to_str(params)
        
        expect(result).to eq("foo, bar")
      end
      
      it "t.foo AND t.bar" do
        params = {:array_vals => ["foo", "bar"],
                  :seperator => " AND ",
                  :prefix => "t."}
        result = GenString.array_to_str(params)
        
        expect(result).to eq("t.foo AND t.bar")
      end
      
      it "[foo.chu|bar.chu|baz.chu]" do
        params = {:array_vals => ["foo", "bar", "baz"],
                  :seperator => "|",
                  :suffix => ".chu",
                  :open_by => "[",
                  :closed_by => "]"}
        result = GenString.array_to_str(params)
        
        expect(result).to eq("[foo.chu|bar.chu|baz.chu]")
      end
    end
    
    describe "arrays_to_str" do
      it "foo=bar" do
        params = {:seperator => ", ",
                  :array_vals1 => ["foo"],
                  :seperator1 => "=",
                  :array_vals2 => ["bar"]}
        result = GenString.arrays_to_str(params)
        
        expect(result).to eq("foo=bar")
      end
      
      it "foo, bar" do
        params = {:array_vals1 => ["foo", "bar"],
                  :seperator1 => ", "}
        result = GenString.arrays_to_str(params)
        
        expect(result).to eq("foo, bar")
      end
      
      it "t.foo AND t.bar" do
        params = {:array_vals1 => ["foo", "bar"],
                  :seperator1 => " AND ",
                  :prefix1 => "t."}
        result = GenString.arrays_to_str(params)
        
        expect(result).to eq("t.foo AND t.bar")
      end
      
      it "[foo.chu|bar.chu|baz.chu]" do
        params = {:array_vals1 => ["foo", "bar", "baz"],
                  :seperator1 => "|",
                  :suffix1 => ".chu",
                  :open_by => "[",
                  :closed_by => "]"}
        result = GenString.arrays_to_str(params)
        
        expect(result).to eq("[foo.chu|bar.chu|baz.chu]")
      end
      
      it "foo1=bar1, foo2=bar2, foo3=bar3" do
        params = {:array_vals1 => ["foo1", "foo2", "foo3"],
                  :seperator1 => "=",
                  :seperator => ", ",
                  :array_vals2 => ["bar1", "bar2", "bar3"]}
        result = GenString.arrays_to_str(params)
        
        expect(result).to eq("foo1=bar1, foo2=bar2, foo3=bar3")
      end
      
      it "zzfoo1aa=bbbar1yy, zzfoo2aa=bbbar2yy, zzfoo3aa=bbbar3yy" do
        params = {:array_vals1 => ["foo1", "foo2", "foo3"],
                  :prefix1 => "zz",
                  :suffix1 => "aa",
                  :seperator1 => "=",
                  :seperator => ", ",
                  :array_vals2 => ["bar1", "bar2", "bar3"],
                  :prefix2 => "bb",
                  :suffix2 => "yy"}
        result = GenString.arrays_to_str(params)
        
        expect(result).to eq("zzfoo1aa=bbbar1yy, zzfoo2aa=bbbar2yy, zzfoo3aa=bbbar3yy")
      end
    end
  end
  
end