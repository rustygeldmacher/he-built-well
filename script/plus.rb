#!/usr/bin/env ruby

lines = File.readlines(ARGV[0])
current_line = next_line = nil

lines.each_with_index do |line, i|
  line = line.rstrip

  if i == 0
    current_line = line
    next
  end

  next_line = line

  if current_line != "" && next_line != "" && current_line !~ /^\s*\[.*\]$/ && current_line !~ /^=/
    puts current_line + " +"
  else
    puts current_line
  end

  current_line = line
end

puts current_line
