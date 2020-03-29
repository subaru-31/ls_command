# frozen_string_literal: true
require "optparse"

module Ls
  class Option

    attr_reader :argument
    def initialize
      @argument = ARGV.getopts("a", "r", "l")
    end
  end
end
