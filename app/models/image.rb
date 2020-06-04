class Image < ActiveRecord::Base
  belongs_to :user
  belongs_to :collection

  require 'aws-sdk-rekognition'
  credentials = Aws::Credentials.new(
     'AKIA2MPVCMTYIFYKBAPV', 'QeM6Nsg+3yimknEgCkegvFjhf5OO6rBUH7VHnb8n')

  client = Aws::Rekognition::Client.new credentials: credentials

  def self.create(userimage)
    @userimage = userimage
  end

  def process
  path_1 = File.expand_path(self)
  file_1 = File.read(path_1)
  resp = client.detect_faces({
    image: {
      bytes: file_1
    }
  })
  resp
  end
end
