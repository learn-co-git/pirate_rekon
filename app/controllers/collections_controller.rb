
class CollectionsController < ApplicationController


  get '/home' do
    if confirm_collection(session).empty?
      @user = current_user(session)
      erb :home
    else
      redirect "/collections/#{:user_id}"
    end
  end
  #technically a user can create more then 1 collection,
  #decided to remove this functionality without actually do so.

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

  get '/index/:id' do    #user id
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

end
