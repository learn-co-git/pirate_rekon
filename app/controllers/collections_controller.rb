
class CollectionsController < ApplicationController


  get '/home' do
    @user = current_user(session)
    if confirm_collection(session).empty?
      erb :home
    else
      redirect "/collections/#{@user.id}"
    end
  end


  get '/collections/:user_id' do
     @collection = Collection.all.select {|record| record.user_id == session[:user_id].to_i}
     @user = User.find_by_id(session[:user_id])
     @images = Image.all.select {|pic| pic.collection_id == session[:user_id]}
     erb :show
  end

  get '/new' do
    erb :new
  end

  get '/index/:id' do
    @user_images = user_images(session)
    erb :index
  end

  post '/collections' do
    @user_collection = Collection.new(:name => params[:collection], :creation_date => Time.now, :user_id => session[:user_id], :num_images => 1)
    @user_collection.save

    Cloudinary::Api.create_folder("#{current_user(session).username}")
    redirect to "/collections/#{@user_collection.user_id}"
  end


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
