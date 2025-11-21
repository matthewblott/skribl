require 'mini_magick'
require 'fileutils'

class RandomLineDrawing
  def self.old_generate(filename, width: 500, height: 500, lines: 20, line_width: 2)
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
    # MiniMagick::Tool::Magick.new do |magick|
    MiniMagick.convert do |magick|
      args.each { |arg| magick << arg }
    end

    # Return the filename
    filename
  end
  
  POINTS = rand(5..10)

  def self.generate(filename, width: 800, height: 600)

    # Ensure the directory exists
    FileUtils.mkdir_p(File.dirname(filename)) unless Dir.exist?(File.dirname(filename))

    # build polygon points like: "10,20 300,40 50,500"
    points = Array.new(POINTS) { "#{rand(width)},#{rand(height)}" }.join(" ")

    # pick a random fill color
    color = "#%06x" % rand(0..0xFFFFFF)

    # output = "tmp/#{filename}.png"

    # Build command as an array to avoid shell-quoting problems.
    # We call `magick` (ImageMagick 7) directly and supply generator "xc:white".
    cmd = [
      "magick",                       # ImageMagick 7 entrypoint
      "-size", "#{width}x#{height}",  # canvas size
      "xc:white",                     # create a white canvas
      "-fill", color,                 # fill color
      "-draw", "polygon #{points}",   # draw polygon
      filename,                       # output file
    ]

    # puts "Running: #{cmd.join(' ')}"

    success = system(*cmd)

    if success
      filename
    end

  end

end
