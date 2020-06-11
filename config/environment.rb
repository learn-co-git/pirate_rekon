ENV['SINATRA_ENV'] ||= "development"

require 'bundler/setup'
require 'pry'
require "cloudinary"
require 'cloudinary/uploader'
require 'cloudinary/utils'
require 'open-uri'
require 'base64'
require 'aws-sdk'
require 'aws-sdk-s3'
require 'httparty'


Aws.config.update({
  region: 'us-west-2',
  credentials: Aws::Credentials.new('AKIA2MPVCMTYMIW5DK4A', 'khGL1/kfd76KmT2/FrJXHoxqM9kSjB75yQFJDjKQ')
})

Bundler.require(:default, ENV['SINATRA_ENV'])

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => "db/#{ENV['SINATRA_ENV']}.sqlite"
)

require_all 'app'
