# frozen_string_literal: true

module Formatter
  def standard_format(files)
    files.each.with_index(1) do |file, integer|
      if integer % 8 == 0 || files.last == file
        puts file.name.ljust(24, " ")
      else
        print file.name.ljust(24, " ")
      end
    end
  end

  def option_l_format(files)
    puts "total #{files.map(&:block).sum}"
    display_file_info(files)
  end

  # fileオブジェクトを並び替える
  def files_sort(files, reverse: false)
    if reverse
      files.sort_by { |file| file.name }.reverse
    else
      files.sort_by { |file| file.name }
    end
  end

  private
    def display_file_info(files)
      files.each do |file|
        output_file_info = +""
        output_file_info << file.type
        output_file_info << file.permission
        output_file_info << "  #{file.nlink}"
        output_file_info << " #{file.owner}"
        output_file_info << "  #{file.group}"
        output_file_info << " #{file.size.to_s.rjust(5, " ")}"
        output_file_info << "  #{file.timestomp}"
        output_file_info << " #{file.name}"
        puts output_file_info
      end
    end
end
