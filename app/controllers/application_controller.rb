class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  require 'httparty'

  configure do
    set :public_folder, 'public'
    set :views, Proc.new { File.join(root, "../views/") }
    enable :sessions
    set :session_secret, "secret" #need to fix this for production, standin ONLY
  end

  helpers do
    def current_user(session)
      @user = User.find(session["user_id"])
    end

    def is_logged_in?(session)
      !session["user_id"].nil?
    end

    def confirm_user(session)
      @user.id == session[:user.id]
    end

    def confirm_collection(session)
      Collection.all.select {|record| record.user_id == session[:user_id]}
    end

    def user_images(session)
      Image.all.select {|picture| session[:user_id] == picture.collection_id}
    end

    def cloud_search(session)
      Cloudinary::Search
      .expression("folder=#{current_user(session).username}")
      .execute
    end
  end

  get "/" do
    erb :welcome
  end

  get '/signup' do
    erb :'/signup'
  end

  post '/signup' do
    if params[:username].empty? || params[:password].empty?
      erb :error
    else
      @user = User.new(:username => params[:username], :email => params[:email], :password => params[:password])
      @user.save
      redirect  '/login'
    end
  end

  post '/login' do #had issues moving data from one controller to another
    @params = params
    user = User.find_by_email(@params[:email])
    if user != nil && user.authenticate(@params[:password])

        @user = User.new(:id => user[:id], :username => user[:username], :email => user[:email], :password => user[:password])

        session[:user_id] = @user.id

        redirect to "/home"
    else
      erb :error
    end
  end

  get '/login' do
    erb :login
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

  get '/error' do
    erb :error
  end

end
