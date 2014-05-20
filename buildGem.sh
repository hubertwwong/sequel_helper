#!/bin/bash
VER="0.0.0"

# loop to read version.txt
while read line
do
  VER=$line
done < version.txt

# appending version number to gem name.
GEM_NAME_VER="sequel_helper-${VER}.gem"
GEM_NAME="sequel_helper.gem"

echo "building gem...."

gem build sequel_helper.gemspec

echo "installing gem...."

gem install $GEM_NAME_VER

echo "moving gem to bin directory...."

mv $GEM_NAME_VER bin/
