  require 'open-uri'

class CollectionsController < ApplicationController


  get '/home' do
    if confirm_collection(session).empty?
      @user = current_user(session)
      erb :home
    else
      redirect "/collections/#{:user_id}"
    end
  end

  get '/collections/:user_id' do #display user and all images
     @collection = Collection.all.select {|record| record.user_id == session[:user_id].to_i}
     @user = User.find_by_id(session[:user_id])
     @images = Image.all.select {|pic| pic.collection_id == session[:user_id]}
     # @images - single image 'url' is @images[i].url
     erb :show
  end

  get '/new' do
    erb :new
  end

  get '/images/new' do #image added to cloud prior step

    result = cloud_search(session) #all user's images
    added_images = result["resources"].length - confirm_collection(session)[0].num_images #determine #of new images just added, SMALL DELAY IN CLOUD STORAGE!

    x = -1
    while added_images >= 0 #add images to my DB
      image = result["resources"][x]
      new_image = Image.new(:name => image["filename"], :url => image["url"], :creation_date => Time.now, :collection_id => session[:user_id])
      #add the new images stored in the cloud to my database
      new_image.save
      confirm_collection(session)[0].num_images += 1 #increment collection num_images

      x -= 1 && added_images -= 1
    end
      @user_images = user_images(session)
    erb :index
  end

  get '/index/:id' do
    @user_images = user_images(session) #show all user images
    erb :index
  end

  post '/collections' do #create new collection
    @user_collection = Collection.new(:name => params[:collection], :creation_date => Time.now, :user_id => session[:user_id], :num_images => 1)
    @user_collection.save

    Cloudinary::Api.create_folder("#{current_user(session).username}")
    redirect to "/collections/#{@user_collection.user_id}"
  end

  #this edit add images to user collection(1 collection/user)
  get '/collections/:user_id/edit' do
     @params = params
     @album = confirm_collection(session)
     @username = current_user(session).username
    erb :edit
  end

  post '/collections/add' do
    redirect '/images/new'
  end

  post '/process' do
    require 'net/http'
    idx1 = (params["imageOne"].to_i) - 1
    idx2 = (params["imageTwo"].to_i) - 1
    source = user_images(session)[idx1].url
    target = user_images(session)[idx2].url
  end
end
