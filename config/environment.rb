ENV['SINATRA_ENV'] ||= "development"

require 'bundler/setup'
require 'pry'
Bundler.require(:default, ENV['SINATRA_ENV'])

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => "db/#{ENV['SINATRA_ENV']}.sqlite"
)
CLOUDINARY_URL='cloudinary://878221219951367:eldWr7Y5drgSfWrc6kg-zN9R3Fo@argustwo'

require_all 'app'
