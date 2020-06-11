

if Cloudinary.config.api_key.blank?
  require './config/initializers/cloudinary.rb'
end

if Cloudinary.config.api_key.blank?
  puts
  puts "Please configure this demo to use your Cloudinary account"
  puts "by copying configuration values from the Management Console"
  puts "at https://cloudinary.com/console into config.rb."
  puts
  exit
end

class CollectionsController < ApplicationController
  require 'open-uri'

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

    result = cloud_search(session) #all users images

    added_images = result["resources"].length - confirm_collection(session)[0].num_images #determine #of new images

    x = -1
    while added_images >= 0 #add images to my DB
      image = result["resources"][x]
      new_image = Image.new(:name => image["filename"], :url => image["url"], :creation_date => Time.now, :collection_id => session[:user_id])
      new_image.save
      confirm_collection(session)[0].num_images += 1 #increment collection num_images

      x -= 1 && added_images -= 1
    end
      @user_images = user_images(session)
    erb :index
  end

  get '/index/:id' do
    @user_images = user_images(session)
    erb :index
  end

  post '/collections' do #create new collection
    @user_collection = Collection.new(:name => params[:collection], :creation_date => Time.now, :user_id => session[:user_id], :num_images => 1)
    @user_collection.save
    Cloudinary::Api.create_folder("#{current_user(session).username}")

    redirect to "/collections/#{@user_collection.user_id}"
  end

  get '/collections/:user_id/edit' do
     @params = params
     @album = confirm_collection(session)
     @username = current_user(session).username
     # binding.pry
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

     # uri = URI("https://res.cloudinary.com/argustwo/image/upload/v1591755690/argus/3.png")
     # @data1 = Net::HTTP.get(uri)
     #
     #
     # uri = URI("https://res.cloudinary.com/argustwo/image/upload/v1591744233/argus/2.png")
     # @data2 = Net::HTTP.get(uri)
     #
     # img1_64 = Base64.strict_encode64(@data1)
     # img2_64 = Base64.strict_encode64(@data2)

     Credentials = Aws::Credentials.new(
        'AKIA2MPVCMTYMIW5DK4A', 'khGL1/kfd76KmT2/FrJXHoxqM9kSjB75yQFJDjKQ')

        # @data1 = ActiveSupport::Base64.encode64(open("https://res.cloudinary.com/argustwo/image/upload/v1591755690/argus/3.png"))
        #
        # @data2 = ActiveSupport::Base64.encode64(open("https://res.cloudinary.com/argustwo/image/upload/v1591744233/argus/2.png"))



        client = Aws::Rekognition::Client.new credentials: Credentials

        photo1 = 'image1.jpeg'
        path1 = './public/images/image1.jpeg'
        photo2 = 'image2.jpeg'
        path2 = './public/images/image2.jpeg'
        file1 = open(path1) {|f| f.read}
        file2 = open(path2) {|f| f.read}

        resp = client.compare_faces({
      similarity_threshold: 90,
      source_image: {
        bytes: file1
      },
      target_image: {
        bytes: file2
      },
    })

    # img1_64 = Base64.strict_encode64(@data1)
    # img2_64 = Base64.strict_encode64(@data2)
    #   binding.pry
    # obj = Image.process(img1_64, img2_64)

    binding.pry
  end

end
