#! /usr/bin/env ruby
require 'docker'
require 'optparse'

NONE_TAG = '<none>:<none>'
NOP_PREFIX = '#(nop) '

options = {}
commands = []

# Default to -h if no arguments
ARGV << '-h' if ARGV.empty?

OptionParser.new do |opts|
  opts.banner = "Usage: dockerfile-from-image.rb [options] <image_id>"

  opts.on("-f", "--full-tree", "Generate Dockerfile for all parent layers") do |f|
    options[:full] = f
  end

  opts.on_tail("-h", "--help", "Show this message") do
    puts opts
    exit
  end
end.parse!

image_id = ARGV.pop
abort('Error: Must specify image ID or tag') unless image_id

# Collect all image tags into a hash keyed by layer ID.
# Used to look-up potential FROM targets.
tags = Docker::Image.all.each_with_object({}) do |image, hsh|
  tag = image.info['RepoTags'].first
  hsh[image.id] = tag unless tag == NONE_TAG
end

loop do
  # If the current ID has a tag, render FROM instruction and break
  # (unless this is the first command)
  if !options[:full] && commands && tags.key?(image_id)
    commands << "FROM #{tags[image_id]}"
    break
  end

  begin
    image = Docker::Image.get(image_id)
  rescue Docker::Error::NotFoundError
    abort('Error: specified image tag or ID could not be found')
  end

  cmd = image.info['ContainerConfig']['Cmd']

  if cmd && cmd.size == 3
    cmd = cmd.last

    if cmd.start_with?(NOP_PREFIX)
      commands << cmd.gsub(NOP_PREFIX,'').gsub(/^USER[ |\t]+\[(.*)\]/,'USER \1')
    else
      commands << "RUN #{cmd}".split.join(' ')
    end
  end

  image_id = image.info['Parent']
  break if image_id == ''
end

puts commands.reverse
