class CollectionsController < ApplicationController

  get '/home' do
    @user = current_user(session)
    erb :home
  end

  get '/collection/:id' do    #use to see all images in the collection
    @collection = Collection.all
    user_collection = []
    user_collection = @collection.each do
      if @collection[:user_id] == session[:user_id]
          user_collection << @collection[:image_id]
      end
    end
  end

  get '/create' do
    
  end

  get '/upload' do
    #route to upload erb
  end
      #need to add an image to user collection
  post '/upload' do
    unless params[:file] &&
           (tmpfile = params[:file][:tempfile]) &&
           (name = params[:file][:filename])
      @error = "No file selected"
      return haml(:upload)
    end
    STDERR.puts "Uploading file, original name #{name.inspect}"
    while blk = tmpfile.read(65536)
      # final location
      STDERR.puts blk.inspect
    end
      "Upload complete"
    end


end
