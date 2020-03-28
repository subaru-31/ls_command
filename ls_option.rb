# frozen_string_literal: true

module Ls
  class Option
    require "optparse"

    attr_reader :argument
    def initialize
      @argument = ARGV.getopts("a", "r", "l")
    end
  end
end
