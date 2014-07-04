#! /usr/local/bin/ruby
require 'docker'

NONE_TAG = '<none>:<none>'
NOP_PREFIX = '#(nop) '

image_id = ARGV.first
commands = []

# Collect all image tags into a hash keyed by layer ID
tags = Docker::Image.all.each_with_object({}) do |image, hsh|
  tag = image.info['RepoTags'].first
  hsh[image.id] = tag unless tag == NONE_TAG
end

loop do
  # If the current ID has a tag, render FROM instruction and break.
  if commands && tags.key?(image_id)
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
      commands << cmd.split(NOP_PREFIX).last
    else
      commands << "RUN #{cmd}"
    end
  end

  image_id = image.info['Parent']
  break if image_id == ''
end

puts commands.reverse
