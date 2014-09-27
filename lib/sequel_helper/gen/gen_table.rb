require_relative "gen_string"
require_relative "../util/log_factory"

# Stuff with tables..
class GenTable

  # mysql clone table. might include others if needed.
  # something like pgsql.
  def self.clone(orig_name, new_name)
    return "CREATE TABLE " + new_name + " LIKE " + orig_name + ";"
  end
  
end
