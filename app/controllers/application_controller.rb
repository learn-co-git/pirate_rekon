require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  credentials = Aws::Credentials.new(
   'AKIA2MPVCMTYIFYKBAPV', 'QeM6Nsg+3yimknEgCkegvFjhf5OO6rBUH7VHnb8n')
   client = Aws::Rekognition::Client.new credentials: credentials

  get "/" do
    erb :welcome
  end

  post "/create" do
  end

end
