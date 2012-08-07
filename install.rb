#!/usr/bin/env ruby

require 'fileutils'

puts "Hello!"

ROOT = File.dirname($0)
HOME = File.dirname(`which \git-flow`)

puts "\nI'm going to install the Agworld variant of git-flow here: '#{HOME}' :)"

unless File.exists?(File.join(HOME, 'gitflow-shFlags'))
  puts "\n(but you need to have git-flow installed already; please do that first)"
  exit 1
end

unless Dir.glob("#{HOME}/*flow*").all? { |file| File.writable?(file) }
  puts "\n(but I can't write that directory; please re-run using 'sudo')"
  exit 2
end

if ARGV.length != 1 && ARGV[0] != 'woof'
  puts "\n(but I need your permission first; please re-run like this: '#{$0} woof')"
  exit 3
end

SAFE = "/tmp/git-flow-old"

puts "\nI'll copy the old git-flow files to '#{SAFE}' first, just in case..."

if File.exist?(SAFE)
  puts "\n(but I can't, because that directory is already there; please move it first)"
  exit 4
end

def copy(item, source, target)
  return unless item =~ /flow/
  return if item =~ /shFlags/
  FileUtils.mkdir_p(target)
  source = File.join(source, item)
  target = File.join(target, item)
  puts "   cp '#{source}' '#{target}'"
  FileUtils.cp(source, target)
end

Dir.foreach(HOME) do |item|
  copy(item, HOME, SAFE)
end

puts "\nAnd now I'll copy the new git-flow files to '#{HOME}'..."

Dir.foreach(ROOT) do |item|
  copy(item, ROOT, HOME)
end

puts "\nAnd that's a wrap!"
