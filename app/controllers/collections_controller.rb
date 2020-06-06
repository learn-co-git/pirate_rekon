class CollectionsController < ApplicationController

  get '/home' do
    @user = current_user(session)
    erb :home
  end

  get '/collections/:user_id' do #display all the users collections
    #binding.pry
     @collection = Collection.all.select {|record| record.user_id == params[:user_id].to_i}
     @user = User.find_by_id(session[:user_id])
     erb :show
  end

  get '/new' do #new collection
    erb :new
  end

  # post '/images/new' do #add image to collection
  #    @album = Collection.all.select {|record| record.user_id == session[:user_id]}[(params[:album].to_i - 1)]
  #    redirect "/collections/#{@album.id}/edit"
  # end

  post '/collections' do #create new collection
    @user_collection = Collection.new(:name => params[:collection], :creation_date => Time.now, :user_id => session[:user_id])
    @user_collection.save
    redirect to "/collections/#{@user_collection.user_id}"
  end

  get '/collections/:user_id/edit' do
    binding.pry
       @album = Collection.all.select {|record| record.user_id == session[:user_id]}
    erb :edit
  end





end
