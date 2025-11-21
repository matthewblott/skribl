# random_shape.rb
WIDTH  = 800
HEIGHT = 600
POINTS = rand(5..10)

# build polygon points like: "10,20 300,40 50,500"
points = Array.new(POINTS) { "#{rand(WIDTH)},#{rand(HEIGHT)}" }.join(" ")

# pick a random fill color
color = "#%06x" % rand(0..0xFFFFFF)

output = "random_shape.png"

# Build command as an array to avoid shell-quoting problems.
# We call `magick` (ImageMagick 7) directly and supply generator "xc:white".
cmd = [
  "magick",                       # ImageMagick 7 entrypoint
  "-size", "#{WIDTH}x#{HEIGHT}",  # canvas size
  "xc:white",                     # create a white canvas
  "-fill", color,                 # fill color
  "-draw", "polygon #{points}",   # draw polygon
  output                          # output file
]

puts "Running: #{cmd.join(' ')}"
success = system(*cmd)

if success
  puts "Saved #{output}"
  puts "Polygon points: #{points}"
  puts "Fill color: #{color}"
else
  warn "ImageMagick command failed (exit #{$? && $?.exitstatus})."
  warn "Try running the same command shown above in your terminal to see ImageMagick errors."
end

