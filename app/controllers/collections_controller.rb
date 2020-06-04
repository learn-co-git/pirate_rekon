require './config/environment'

class CollectionsController < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  configure do
    set :public_folder, 'public'
    set :views, Proc.new { File.join(root, "../app/views") }
  end

  get './collections_controller/home' do
    erb :home
  end
end
