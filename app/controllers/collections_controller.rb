class CollectionsController < ApplicationController

  get '/home' do
    @user = current_user(session)
    erb :home
  end

  get '/collections/:user_id' do #display all the users collections
    #binding.pry
     @collection = Collection.all.select {|record| record.user_id == params[:user_id].to_i}
     @images = Image.all
     erb :show
  end

  get '/new' do #new collection
    erb :new
  end

  get 'images/new' do #add new image to existing collection
    erb :images_new
  end

  post '/collections' do #create new collection
    @user_collection = Collection.new(:name => params[:collection], :creation_date => Time.now, :user_id => session[:user_id])
    @user_collection.id = session[:user_id]
    @user_collection.save
    redirect to "/collections/#{@user_collection.user_id}"
  end





end
