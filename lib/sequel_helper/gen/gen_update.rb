require_relative "gen_string"

class GenUpdate
  
  attr_accessor :low_priority_flag, :ignore_flag, :table_ref,
                :set_ref, :where_ref, :order_ref, :limit_ref
  
  # trying to create a statement below...
  # table_ref = "foo f LEFT JOIN bar b ON ..."
  # set_col = "...."
  #
  # probably fix this later...
  # for naming conventions...
  # use the _ref suffix for compliated statements....
  #
  # UPDATE foo f LEFT JOIN bar b ON f.symbol=b.symbol AND f.date=b.date
  # SET b.open=f.open, b.high=f.high, b.low=f.low, b.close=f.close, b.adj_close=f.adj_close, b.volume=f.volume;
  #  
  def self.update(params = {})
    # make some of the params optional.
    params = {
              low_priority_flag: nil,
              ignore_flag: nil,
              where_ref: nil,
              order_ref: nil,
              limit_ref: nil
             }.merge(params)
             
    # load params into variables.
    # ###########################
    low_priority_flag = params.fetch(:low_priority_flag)
    ignore_flag = params.fetch(:ignore_flag)
    table_ref = params.fetch(:table_ref)
    set_ref = params.fetch(:set_ref)
    where_ref = params.fetch(:where_ref)
    order_ref = params.fetch(:order_ref)
    limit_ref = params.fetch(:limit_ref)
    
    # INTIAL CHECKS
    ###############
    
    if table_ref == nil
      puts "error: need to define a table reference."
      return nil
    end
    
    if set_ref == nil
      puts "error: need to define a set reference."
      return nil
    end
    
    # construct the db string.
    ##########################
    
    # initial sql statemet
    db_str = "UPDATE"
    
    db_str = GenString.append_if_true(db_str, " LOW_PRIORITY", low_priority_flag)
    db_str = GenString.append_if_true(db_str, " IGNORE", ignore_flag)
    
    # appending table ref
    db_str += " " + table_ref
    
    # update set.
    db_str += " SET " + set_ref
    
    # optional condition...
    db_str = GenString.append_not_nil(db_str, " WHERE " + where_ref.to_s, where_ref)
    db_str = GenString.append_not_nil(db_str, " ORDER " + order_ref.to_s, order_ref)
    db_str = GenString.append_not_nil(db_str, " LIMIT " + limit_ref.to_s, limit_ref)
    
    # add the semi colon
    db_str += ";"
    
    # debug stuff
    GenString.pp db_str
    
    return db_str
  end
  
end