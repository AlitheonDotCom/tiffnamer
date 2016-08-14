#!/usr/bin/env ruby
#
# Extracts TIFF image metadata and prepends it to the image's filename
#

require 'fileutils'
require 'open3'

ARG_MAP = Hash[*ARGV]
IMAGE_DIR = ARG_MAP['--image-dir'] || './images/'
DRY_RUN = (ARG_MAP['--dry-run'] || 'false').downcase == 'true'
TAG_INDEX = (ARG_MAP['--tag-index'] || '65007').to_i
UNDO_MODE = (ARG_MAP['--undo'] || 'false').downcase == 'true'

IMAGE_DIR += File::SEPARATOR unless IMAGE_DIR.end_with?(File::SEPARATOR)

# Test if tiffinfo is available on the path
raise 'tiffinfo was not found. Please install tiffinfo and ensure it is available on your PATH' unless system('which tiffinfo > /dev/null 2>&1')

raise "image-dir '#{IMAGE_DIR}' was not found." unless Dir.exists?(IMAGE_DIR)

Dir.glob(IMAGE_DIR + '*.tiff') do |filename|
  basename = File.basename(filename)

  begin
    puts "INFO: Processing '#{basename}'..."

    stdout, stdeerr, status = Open3.capture3("tiffinfo -r \"#{filename}\"")

    tag_line = stdout.split("\n").select { |x| x.match("^\\s*Tag #{TAG_INDEX}:.*") }.first
    tag_val = tag_line.gsub("Tag #{TAG_INDEX}:", '').strip rescue nil

    if (tag_val)
      prefix = tag_val.gsub(/[^\w\.]/, '-')
      if (!UNDO_MODE &&  File.basename(filename).start_with?(prefix) ||
           UNDO_MODE && !File.basename(filename).start_with?(prefix))
        puts "INFO: Skipping '#{basename}' because it has already been renamed"
        next
      end

      if (UNDO_MODE)
        new_filename = filename.gsub(prefix + '_', '')
      else
        new_filename = File.join(File.dirname(filename), prefix + '_' + File.basename(filename))
      end

      if (DRY_RUN)
        puts "mv \"#{filename}\" \"#{new_filename}\""
      else
        FileUtils.mv(filename, new_filename, {:force => true})
      end
    else
      puts "WARNING: File '#{basename}' does not contain tag #{TAG_INDEX}"
    end
  rescue Exception => e
    puts "ERROR: Failed to process '#{basename}': #{e.message}"
  end
end
