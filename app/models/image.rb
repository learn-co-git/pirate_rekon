require 'aws-sdk-rekognition'
require 'net/http'
require 'uri'
class Image < ActiveRecord::Base
  belongs_to :collection

  #this needs to be made secret for production
  Credentials = Aws::Credentials.new(
     'AKIA2MPVCMTYMIW5DK4A', 'khGL1/kfd76KmT2/FrJXHoxqM9kSjB75yQFJDjKQ')

  def open(url)
    Net::HTTP.get(URI.parse(url))
  end

  def self.process(source, target)
     client = Aws::Rekognition::Client.new credentials: Credentials

     file1 = open(source) {|f| f.read}
     file2 = open(target) {|f| f.read}

     resp = client.compare_faces({
       similarity_threshold: 90,
       source_image: {
         bytes: file1
       },
       target_image: {
         bytes: file2
       },
      })
  end
end
