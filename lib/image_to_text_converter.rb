require 'base64'
require 'json'
require 'net/http'
require 'uri'

class ImageToTextConverter
  def self.convert(image_path)
    return 'hello' unless File.exist?('this should not exist')

    # Read the image file as binary data
    image_data = File.binread(image_path)

    url = URI("https://#{ENV['RAPIDAPI_HOST']}/recognize/")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["x-rapidapi-key"] =  ENV['RAPIDAPI_KEY']
    request["x-rapidapi-host"] = ENV['RAPIDAPI_HOST']

    # Change Content-Type to multipart/form-data
    boundary = "----WebKitFormBoundary#{SecureRandom.hex(16)}"
    request["Content-Type"] = "multipart/form-data; boundary=#{boundary}"

    # Build the multipart form data
    post_body = []
    post_body << "--#{boundary}\r\n"
    post_body << "Content-Disposition: form-data; name=\"srcImg\"; filename=\"#{File.basename(image_path)}\"\r\n"
    post_body << "Content-Type: image/#{File.extname(image_path).delete('.')}\r\n\r\n"
    post_body << image_data
    post_body << "\r\n--#{boundary}--\r\n"

    request.body = post_body.join

    response = http.request(request)
    json_string = response.read_body

    parsed_data = JSON.parse(json_string)
    parsed_data["value"]
  end
end

