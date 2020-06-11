require 'aws-sdk-rekognition'

class Image < ActiveRecord::Base
  belongs_to :collection

  #this needs to be made secret for production
  Credentials = Aws::Credentials.new(
     'AKIA2MPVCMTYMIW5DK4A', 'khGL1/kfd76KmT2/FrJXHoxqM9kSjB75yQFJDjKQ')

  def self.process(img1Url, img2Url)
     client = Aws::Rekognition::Client.new credentials: Credentials

     #photo1 = 'image1.jpeg'
     path1 = '(img1Url)'
     #photo2 = 'image2.jpeg'
     path2 = '(img2Url)'
     file1 = open(path1) {|f| f.read}
     file2 = open(path2) {|f| f.read}

     resp = client.compare_faces({
       similarity_threshold: 90,
       source_image: {
         bytes: file1
       },
       target_image: {
         bytes: file2
       },
      })
  binding.pry
  end
end
