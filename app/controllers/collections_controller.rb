class CollectionsController < ApplicationController

  get '/home' do
    @user = current_user(session)
    erb :home
  end

  get '/collections/:id' do
     @collection = Collection.find(params[:id])
     erb :show
  end

  get '/new' do
    erb :new
  end

  post '/collections' do
    @user_collection = Collection.new(:name => params[:collection], :creation_date => Time.now, :user_id => session[:user_id])
    @user_collection.save
    redirect "/collections/#{@user_collection.id}"
  end





end
