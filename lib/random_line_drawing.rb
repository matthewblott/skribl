require 'mini_magick'
require 'fileutils'

class RandomLineDrawing
  def self.generate(filename, width: 500, height: 500, lines: 20, line_width: 2)
    # Ensure the directory exists
    FileUtils.mkdir_p(File.dirname(filename)) unless Dir.exist?(File.dirname(filename))
    
    # Build the command arguments
    args = []
    args << "-size" << "#{width}x#{height}"
    args << "xc:white"
    args << "-stroke" << "black"
    args << "-strokewidth" << line_width.to_s
    
    # Add drawing commands
    lines.times do
      x1, y1 = rand(width), rand(height)
      x2, y2 = rand(width), rand(height)
      args << "-draw" << "line #{x1},#{y1} #{x2},#{y2}"
    end
    
    # Save to file
    args << filename
    
    # Use the recommended approach for ImageMagick 7
    MiniMagick::Tool::Magick.new do |magick|
      args.each { |arg| magick << arg }
    end
    
    # Return the filename
    filename
  end
end
