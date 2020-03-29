# frozen_string_literal: true

require "etc"

module Ls
  class FileOrDirectory
    attr_reader :name

    def initialize(path, name)
      @path = path
      @name = name
    end

    def block
      File.stat(@path).blocks
    end

    def permission
      shape_permission(File.stat(@path).mode.to_s(8))
    end

    def type
      shape_file_type(File.stat(@path).ftype)
    end

    def nlink
      File.stat(@path).nlink
    end

    def owner
      Etc.getpwuid(File.stat(@path).uid).name
    end

    def group
      Etc.getgrgid(File.stat(@path).gid).name
    end

    def size
      File.stat(@path).size
    end

    def timestomp
      File.stat(@path).mtime.strftime("%-m %e %H:%M")
    end

    private
      def shape_permission(permission_integer)
        permission = +""
        permission_array =
          if permission_integer.size == 6
            permission_integer.split("", 4).last.chars
          else
            permission_integer.split("", 3).last.chars
          end
        permission_array.each do |integer|
          case integer
          when "0"
            permission << "---"
          when "1"
            permission << "--x"
          when "2"
            permission << "-w-"
          when "3"
            permission << "-wx"
          when "4"
            permission << "r--"
          when "5"
            permission << "r-x"
          when "6"
            permission << "rw-"
          when "7"
            permission << "rwx"
          end
        end
        permission
      end

      def shape_file_type(file)
        case file
        when "file"
          "-"
        when "directory"
          "d"
        when "link"
          "l"
        end
      end
  end
end
