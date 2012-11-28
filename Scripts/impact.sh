#!/usr/bin/env ruby

impact = Hash.new(0)

IO.popen("git log --pretty=format:\"%an\" --shortstat #{ARGV.join(' ')}") do |f|
  prev_line = ''
  while line = f.gets
    changes = /(\d+) insertions.*(\d+) deletions/.match(line)

    if changes
      impact[prev_line] += changes[1].to_i + changes[2].to_i
    end

    prev_line = line # Names are on a line of their own, just before the stats
  end
end

impact.sort_by { |a,i| -i }.each do |author, impact|
  puts "#{author.strip}: #{impact}"
end