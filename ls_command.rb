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
      sort_files = files_sort(files, reverse: option_hash(argument_type)["reverse"])
      display_format(sort_files, format_type: option_hash(argument_type)["format"])
    end

    private
      def judge_argument_type(argument)
        argument_types = {
          { "a" => false, "r" => false, "l" => false } => "オプションなし",
          { "a" => true, "r" => true, "l" => true } => "-alr",
          { "a" => true, "r" => false, "l" => false } => "-a",
          { "a" => false, "r" => true, "l" => false } => "-r",
          { "a" => false, "r" => false, "l" => true } => "-l",
        }
        argument_types[argument]
      end

      def display_file(argument)
        if argument["a"]
          Dir.glob("*", File::FNM_DOTMATCH)
        else
          Dir.glob("*")
        end
      end

      def create_files(path, argument)
        files = []
        Dir.chdir(path) do |current_path|
          Array(display_file(argument)).each do |file_name|
            files << Ls::FileOrDirectory.new(current_path + "/#{file_name}", file_name)
          end
        end
        files
      end

      def option_hash(argument_type)
        option = {
          "オプションなし" => { "reverse" => false, "format" => "standard" },
          "-alr" => { "reverse" => true, "format" => "l_format" },
          "-a" => { "reverse" => false, "format" => "standard" },
          "-r" => { "reverse" => true, "format" => "standard" },
          "-l" => { "reverse" => true, "format" => "l_format" },
        }
        option[argument_type]
      end

      def display_format(sort_files, format_type:)
        if format_type == "standard"
          standard_format(sort_files)
        elsif format_type == "l_format"
          option_l_format(sort_files)
        end
      end
  end
end
