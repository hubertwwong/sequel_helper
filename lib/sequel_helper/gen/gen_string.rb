# some generic string generating functions.
# stuff like create a string from a array of strings.
class GenString
  
  # compound functions.
  ############################################################################
  
  # converts an array of string to a paren closed one.
  def self.paren_array_to_comma_str(array_params)
    comma_str = self.array_to_comma_str(array_params)
    return self.enclose_with_paren(comma_str)
  end
  
  # conditional strings.
  ############################################################################
  
  # appends a string if the argument isn't nil.
  # if it is nil, just return the main string.
  def self.append_not_nil(main_str, str_to_append, space_flag=false)
    if main_str != nil && str_to_append != nil && space_flag
      return main_str + " " + str_to_append
    elsif main_str != nil && str_to_append != nil
      return main_str + str_to_append
    elsif main_str != nil
      return main_str
    else
      return nil
    end  
  end

  # appends a string if the argument is true.
  # if it is nil, just return the main string.
  def self.append_if_true(main_str, str_to_append, bool_value, space_flag=false)
    if main_str != nil && str_to_append != nil && bool_value && space_flag
      return main_str + " " + str_to_append
    elsif main_str != nil && str_to_append != nil && bool_value
      return main_str + str_to_append
    elsif main_str != nil
      return main_str
    else
      return nil
    end  
  end

  
  # returns a string that the user passes for the first true value.
  # saves you the hasssle of if elsing bunch of true false flags.
  # takes a double array.
  # returns a nil if there is an error.
  #
  # input:
  #   [[false, " bar"]. [true " foo"]]
  # output:
  #   " foo"
  def self.bool_first(array_params)
    if array_params == nil || !array_params.kind_of?(Array)
      return nil
    elsif
      array_params.each do |cur_param|
        if !array_params.kind_of?(Array)
          return nil
        elsif cur_param[0] == true
          return cur_param[1]
        end
      end
    end
    
    # if it gets here, it didn't find a result.
    # return nil.
    return nil
  end
  
  # enclosing strings.
  ############################################################################
  
  # encloses a string with a open and close parenthese.
  def self.enclose_with_paren(some_str)
    if some_str != nil
      return "\(" + some_str.to_s + "\)"
    else
      return nil
    end
  end
  
  # encloses a string with a open and close parenthese.
  def self.enclose_with_single_quote(some_str)
    if some_str != nil
      return "'" + some_str.to_s + "'"
    else
      return nil
    end
  end
  
  # convert array to string
  ############################################################################
  
  # covert an array of strings to a comma string.
  # 
  # input:
  #   ["foo", "bar", "baz"]
  # output:
  #   "foo, bar, baz"
  def self.array_to_comma_str(array_params)
    return self.array_to_str({:array_vals => array_params,
                              :seperator => ", "})
  end
  
  # a more generic version of the array to str 
  # probably wont' do the check it..
  # me thinks its going to be something like this...
  # 
  # still have open close by...
  # but then you have 
  # arrray vals 1
  # prefix 1
  # suffix 1
  # seperator 1.
  # 
  # you dont' have the last seperator...
  # 
  # probably need to fix a few things....
  # in the other code.
  # need to remove the params.fetch?
  # 
  def self.arrays_to_str(params = {})
    params = {
              open_by: nil,
              closed_by: nil
             }.merge(params)
    
    final_str = ""
    array_vals_str = "array_vals"
    # max number of arrays vals.
    max_array_vals = 1
    # number of items of arrays in per array. using first one.
    max_array_item_vals = params[(array_vals_str + "1").to_sym].length
    
    puts "array length" + max_array_item_vals.to_s
    
    # can use these if you want something to enclose the list.
    # like [] or ()...
    open_by = params.fetch(:open_by)
    closed_by = params.fetch(:closed_by)
    
    # checking parmas....
    # probably dumb initially.. just check array_vals1-n
    # and figure out how many that items are using.
    # and go off there.
    # need to fix later.
    while true
      if params.has_key?(("array_vals" + max_array_vals.to_s).to_sym)
        max_array_vals += 1
      else
        # if it can't find a symbol, back up 1 and return it.
        max_array_vals -= 1
        break
      end
    end
    
    # construct the string.
    #######################
    
    if max_array_vals == 0
      return nil
    elsif max_array_vals == 1
      # only 1 params.
      
      # oppening plus 1st array val
      final_str = open_by.to_s + 
                  params["prefix1".to_sym].to_s + 
                  params[(array_vals_str + "1").to_sym][0] + 
                  params["suffix1".to_sym].to_s
      
      # middle stuff
      params[(array_vals_str + "1").to_sym].each_with_index do |array_val, i|
        # skip the first item since you used it already.
        if i != 0
          final_str += params["seperator1".to_sym].to_s + 
                       params["prefix1".to_sym].to_s + 
                       array_val + 
                       params["suffix1".to_sym].to_s
        end
      end
      
      # closing
      final_str += closed_by.to_s
    else
      # multiple array params.
      
      # open param
      final_str = open_by.to_s
      
      # note about seperators naming and using them.
      # if you have 2 list.
      # use seperator 1 and not seperator 2.
      # this will keep thinks consistent when you only have 1 list items.
      # use "seperator" to seperate after all terms.
      
      # first set of params...
      ########################
      cur_index = 1
      while true
        puts "1st<<<<<<<<<<<<<<<<" + cur_index.to_s
        puts params[(array_vals_str + cur_index.to_s).to_sym].to_s
        puts params[(array_vals_str + cur_index.to_s).to_sym][0].to_s
        puts ">>>>>>>>>>>>>>>>"
        
        # don't add the seperator for first item
        if cur_index == 1
          final_str += params[("prefix" + cur_index.to_s).to_sym].to_s + 
                       params[(array_vals_str + cur_index.to_s).to_sym][0].to_s + 
                       params[("suffix" + cur_index.to_s).to_sym].to_s
        else
          final_str += params[("seperator" + (cur_index-1).to_s).to_sym].to_s + 
                       params[("prefix" + cur_index.to_s).to_sym].to_s + 
                       params[(array_vals_str + cur_index.to_s).to_sym][0].to_s +
                       params[("suffix" + cur_index.to_s).to_sym].to_s
        end
        # need a check for the last set of condtions.
        
        cur_index += 1
        
        # exit condition...
        # checking against array length.
        # just use the first array val. assuming the list are all of the same size.
        if cur_index > max_array_vals
          break
        end
      end
      
      # rest of the params...
      #######################  
      cur_index = 1
      # outer loop for terms
      while true
        # term seperator
        final_str += params["seperator".to_sym].to_s
        
        cur_inner_index = 1
        while true
          puts "2nd<<<<<<<<<<<<<<<<"
          puts params[(array_vals_str + cur_index.to_s).to_sym].to_s
          puts params[(array_vals_str + cur_index.to_s).to_sym][cur_inner_index].to_s
          puts ">>>>>>>>>>>>>>>>"
          
          # don't add the seperator for first item of the item.
          if cur_inner_index == 0
            final_str += params[("prefix" + cur_index.to_s).to_sym].to_s + 
                         params[(array_vals_str + cur_inner_index.to_s).to_sym][cur_index].to_s + 
                         params[("suffix" + cur_index.to_s).to_sym].to_s
          else
            final_str += params[("seperator" + (cur_index-1).to_s).to_sym].to_s + 
                         params[("prefix" + cur_index.to_s).to_sym].to_s + 
                         params[(array_vals_str + cur_inner_index.to_s).to_sym][cur_index].to_s + 
                         params[("suffix" + cur_index.to_s).to_sym].to_s
          end
          
          cur_inner_index += 1
          
          puts cur_inner_index.to_s + "+" + max_array_item_vals.to_s 
          
          # check if you are at the end of the array list.
          if cur_inner_index > max_array_vals
            break
          end
        end
        
        # not sure of terms...
        # out looop for terms....
        # 
        
        # eac term increment.
        cur_index += 1
        
        puts cur_index.to_s + "++" + max_array_vals.to_s 
        
        # exit condition...
        # checking against array length.
        # just use the first array val. assuming the list are all of the same size.
        if cur_index >= max_array_item_vals
          break
        end
      end
      
      # closing
      final_str += closed_by.to_s
    end
    
    # return the string.
    return final_str    
  end
  
  # a low level array to string. using low level in quotes.
  # i'm trying to keep it flexible.
  #
  # but takes an array of values and convert it to a string
  #
  # so lets say you have this list.
  # ["foo", "bar", "baz"]
  # and this prefix.
  # "f."
  # and this seperator
  # ", "
  # the result would be.
  # "f.foo, f.bar, f.baz" 
  def self.array_to_str(params = {})
    # make some of the params optional.
    params = {
              open_by: nil,
              closed_by: nil,
              prefix: nil,
              suffix: nil
             }.merge(params)
             
    array_vals = params.fetch(:array_vals)
    # seperator between array values. need to add spacing yourself.
    seperator = params.fetch(:seperator)
    # add a str before each array value
    prefix = params.fetch(:prefix)
    # add a str after each array value
    suffix = params.fetch(:suffix)
    
    # can use these if you want something to enclose the list.
    # like [] or ()...
    open_by = params.fetch(:open_by)
    closed_by = params.fetch(:closed_by)
    
    # intial checks.
    if array_vals == nil || seperator == nil
      return nil
    end
    
    # construct stru.
    final_str = open_by.to_s + prefix.to_s + array_vals[0] + suffix.to_s
    
    # load first param.
    array_vals.each_with_index do |array_val, i|
      # skip the first item since you used it already.
      if i != 0
        final_str = final_str + seperator.to_s + 
                    prefix.to_s + array_val + suffix.to_s
      end
    end
    
    # closing brace if needed.
    final_str = final_str + closed_by.to_s
    
    return final_str
  end
  
  # DEBUG
  ############################################################################
  
  # a simple debug statement.
  def self.pp(db_str)
    puts ">> gen_str [" + db_str + "]"
  end
  
end