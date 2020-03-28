#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "./ls_command"

command = Ls::Command.new(Ls::Option.new.argument)
command.exec
