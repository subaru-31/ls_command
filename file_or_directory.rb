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
          integers = {
            "0" => "---",
            "1" => "--x",
            "2" => "-w-",
            "3" => "-wx",
            "4" => "r--",
            "5" => "r-x",
            "6" => "rw-",
            "7" => "rwx"
          }
          permission << integers[integer]
        end
        permission
      end

      def shape_file_type(file)
        file_types = {
          "file" => "-",
          "directory" => "d",
          "link" => "l"
        }
        file_types[file]
      end
  end
end
