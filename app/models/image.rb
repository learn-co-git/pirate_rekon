require 'aws-sdk-rekognition'

class Image < ActiveRecord::Base
  belongs_to :collection

  # credentials = Aws::Credentials.new(
  #    'AKIA2MPVCMTYLDRLYSNI', '2t4pNfjGhiiPFU2efjB6QoMDaO/cSj9xslrzHW7/ ')
  #
  # client = Aws::Rekognition::Client.new credentials: credentials
  #
  # def self.create(userimage)
  #   @userimage = userimage
  # end
  #
  # def process
  # path_1 = File.expand_path(self)
  # file_1 = File.read(path_1)
  # resp = client.detect_faces({
  #   image: {
  #     bytes: file_1
  #   }
  # })
  # resp
  # end
end
