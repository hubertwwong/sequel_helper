#!/bin/bash
echo "building gem"
gemName="sequel_helper-0.0.1.gem"

gem build sequel_helper.gemspec
gem install $gemName
mv $gemName bin

bundle exec rspec