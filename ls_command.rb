# frozen_string_literal: true

require_relative "./ls_option"
require_relative "./file_or_directory"
require_relative "./formatter"

module Ls
  class Command
    include Formatter
    attr_reader :argument

    def initialize(argument)
      @argument = argument
    end

    def exec
      path = Dir.getwd
      argument_type = judge_argument_type(argument)
      files = create_files(path, argument)

      case argument_type
      when "オプションなし"
        sort_files = files_sort(files)
        standard_format(sort_files)
      when "-alr"
        sort_files = files_sort(files, reverse: true)
        option_l_format(sort_files)
      when "-a"
        sort_files = files_sort(files)
        standard_format(sort_files)
      when "-r"
        sort_files = files_sort(files, reverse: true)
        standard_format(sort_files)
      when "-l"
        sort_files = files_sort(files)
        option_l_format(sort_files)
      end
    end

    private
      def judge_argument_type(argument)
        if !argument["a"] && !argument["r"] && !argument["l"]
          "オプションなし"
        elsif argument["a"] && argument["r"] && argument["l"]
          "-alr"
        elsif argument["a"]
          "-a"
        elsif argument["r"]
          "-r"
        elsif argument["l"]
          "-l"
        else
          ""
        end
      end

      def create_files(path, argument)
        files = []
        if argument["a"]
          Dir.chdir(path) do |current_path|
            Array(Dir.glob("*", File::FNM_DOTMATCH)).each do |file_name|
              files << Ls::FileOrDirectory.new(current_path + "/#{file_name}", file_name)
            end
          end
        else
          Dir.chdir(path) do |current_path|
            Array(Dir.glob("*")).each do |file_name|
              files << Ls::FileOrDirectory.new(current_path + "/#{file_name}", file_name)
            end
          end
        end
        files
      end
  end
end
