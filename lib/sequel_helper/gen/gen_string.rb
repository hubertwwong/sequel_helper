# some generic string generating functions.
# stuff like create a string from a array of strings.
class GenString
  
  # compound functions.
  ############################################################################
  
  # converts an array of sttring to a paren closed one.
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

  # NOT TESTED.
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
    if array_params == nil
      return nil
    elsif array_params.length == 1
      return array_params[0]
    elsif array_params.length > 0
      # load first param.
      final_str = array_params[0]
      
      # load other strings.
      array_params.each_with_index do |array_param, i|
        # skip the first item since you used it already.
        if i != 0
          final_str = final_str + ", " + array_param
        end
      end
      
      # return it.
      return final_str
    end
    
    # if it fails the param checks,
    # return nil. user didn't enter a correct value.
    return nil
  end
  
  # a low level array to string. using low level in quotes.
  # i'm trying to keep it flexible.
  #
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