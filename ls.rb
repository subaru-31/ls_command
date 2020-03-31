#!/usr/bin/env ruby
# frozen_string_literal: true

require "etc"
require "optparse"
require_relative "./ls_command"

command = Ls::Command.new(Ls::Option.new.argument)
command.exec
