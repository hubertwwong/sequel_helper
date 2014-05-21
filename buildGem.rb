# simple script to build a gem and move it to the bin diectory.

# variables.
cur_ver = nil
gem_name = "sequel_helper.gem"
gem_name_ver = nil
gem_spec_name = "sequel_helper.gemspec"

# read version.txt
# just assuming its on the first line.
file = File.new("version.txt", "r")
while (line = file.gets)
    #puts "#{line}"
    cur_ver = line
    break
end
file.close

# gem name.
gem_name_ver = "sequel_helper-" + cur_ver + ".gem"
#puts gem_name_ver

# building gem.
puts "building gem"
system "gem build " + gem_spec_name

# installing gem
puts "installing gem"
system "gem install " + gem_name_ver

# moving gem
puts "moving gem to bin directory"
system "mv " + gem_name_ver + " bin"

puts "complete"

# misc notes
#
# note. use system over eval.
# system allows you to use multiple commands.
