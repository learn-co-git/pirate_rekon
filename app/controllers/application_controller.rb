require './config/environment'

class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  configure do
    set :public_folder, 'public'
    set :views, Proc.new { File.join(root, "../views/") }
    enable :sessions
    set :session_secret, "secret" #need to fix this for production, standin ONLY
  end

  get "/" do
    erb :welcome
  end

  get '/signup' do
    erb :'/signup'
  end

  post '/signup/user' do
    @user = User.new(username: params["name"], email: params["email"], password: params["password"])
    @user.save
    session[:user_id] = @user.id

    redirect  '/controllers/collections_controller/home'
  end

  post '/login' do
   @user = User.find_by(params)
    if @user != nil && params[:password] == @user.password
      session[:user_id] = @user.id
      redirect '/controllers/collections_controller/home'
    else
      erb :error
    end
  end

  get '/logout' do
    session.clear
    redirect '/'
  end




end
