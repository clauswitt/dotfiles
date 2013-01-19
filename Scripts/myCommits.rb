#!/usr/bin/env ruby

myCommits=`git --no-pager log --no-merges --pretty=oneline --author=#{ARGV[0]} |wc -l`
allCommits=`git --no-pager log --no-merges --pretty=oneline  |wc -l`
myPercent=myCommits.to_f/allCommits.to_f*100

puts "My Commits: #{myPercent.to_f}%"
