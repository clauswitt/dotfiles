#!/usr/bin/env ruby

# Pow Port
#
# Quickly and easily change the port that Pow is running on. This allows
# you too run Apache and Pow side-by-side (on different ports of course).
#
# WARNING: This will OVERWRITE your ~/.powconfig file.  If you have custom
# configurations in there, please back it up first.
#
# This file must be executable (chmod +x pow_port.rb)
# This must be ran with administrative privelages (sudo).
#
# Usage:
# sudo ./pow_port.rb <new_port>
#
# Author:    Dan Horrigan <http://dhorrigan.com>
# Copyright: 2011 Dan Horrigan
# License:   MIT License

if ARGV[0].nil?
  puts 'Usage: sudo ./pow_port.rb <new_port>'
  exit
end

new_port = ARGV[0]
rule_num = nil
fw_rules = `sudo ipfw list`

fw_rules.split("\n").each do |rule|
  unless rule.index(",20559 ").nil?
    rule_num = rule.split(" ")[0]
    break
  end
end

if rule_num.nil?
  puts "Could not find the firewall rule.  Are you sure you have Pow installed?"
  exit
end

system("sudo ipfw delete #{rule_num}")
system("sudo ipfw add fwd 127.0.0.1,20559 tcp from any to me dst-port #{new_port} in 1> /dev/null")

File.open(File.expand_path("~/.powconfig"), 'w+') {|f| f.write("export POW_DST_PORT=#{new_port}") }

puts "Pow is now running on port #{new_port}! You may need to restart your browser to see the results."