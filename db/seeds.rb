# Create 100 notes
100.times.with_index do |i|
  Note.create(
    content: "Note # #{i + 1}",
  )
  puts "Created note #{i + 1}"
end

