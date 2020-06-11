require 'aws-sdk-rekognition'

class Image < ActiveRecord::Base
  belongs_to :collection

    Credentials = Aws::Credentials.new(
       'AKIA2MPVCMTYMIW5DK4A', 'khGL1/kfd76KmT2/FrJXHoxqM9kSjB75yQFJDjKQ')


  #
  # def self.create(userimage)
  #   @userimage = userimage
  # end

   def self.holder()
     client = Aws::Rekognition::Client.new credentials: Credentials
     resp = client.get_access_point({
   account_id: "714015401200", # required
   name: "piraterekon", # required
 })
     # s3 = Aws::S3::Client.new
     # resp = s3.list_buckets
     # resp.buckets.map(&:name)
end
# client = Aws::Rekognition::Client.new credentials: Credentials
#   #
#   # def process
#   # path_1 = File.expand_path(self)
#   # file_1 = File.read(path_1)
#   resp = client.detect_faces({
#     image: {
#       bytes: x
#     }
#   })
#   resp
#   end
# end
  # def self.s3_add(datasource)
  #   s3 = Aws::S3::Resource.new(region: 'us-west-2')
  #   obj = s3.bucket('piraterekon').object('compareimage')
  #   url = URI.parse(obj.presigned_url(:put))
  #   # The contents of your object, as a string
  #     body = 'datasource'
  #       Net::HTTP.start(url.host) do |http|
  #           http.send_request('PUT', url.request_uri, body,
  #                  # Or else Net::HTTP adds a default, unsigned content-type
  #                 'content-type' => '')
  #               end
  #   end

    def self.process(source, target)
      client = Aws::Rekognition::Client.new credentials: Credentials
      resp = client.compare_faces({
    similarity_threshold: 90,
    source_image: {
      'Bytes': source
    },
    target_image: {
      'Bytes': target
    },
  })
end
end
