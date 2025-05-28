#!/usr/bin/env ruby

next_line = nil
File.readlines(ARGV[0]).each do |line|
  line = line.strip
  if next_line
    line = next_line + line
    next_line = nil
  end
  if line.end_with?("-") && line != "--"
    begin
      next_line = line.match(/ (\w*)-$/)[1]
    rescue
      # STDERR.puts "Can't parse line: #{line}"; exit
    end
    line = line.gsub(/ (\w*)-$/, '')
  end
  puts line
end
