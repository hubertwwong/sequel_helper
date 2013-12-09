#!/bin/bash
echo "building gem"
gemName="mysql2_helper-0.0.1.gem"

gem build mysql2_helper.gemspec
gem install $gemName
mv $gemName bin