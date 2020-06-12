
  class ImagesController < ApplicationController
    require 'open-uri'



  get '/images/new' do #image added to cloud prior step

    result = cloud_search(session) #all user's images
    current_album = user_images(session)
    current_album_urls = []
    current_album.each {|image| current_album_urls << image.url}
    file = result["resources"].flatten
    (0...file.length).each do |i|
      if (current_album_urls.include?(file[i]["url"]))
      else
        new_image = Image.new(:name => file[i]["filename"], :url => file[i]["url"], :creation_date => Time.now, :collection_id => session[:user_id], :public_id => file[i]["public_id"])
        binding.pry
        new_image.save
        confirm_collection(session)[0].num_images += 1 #increment collection num_images
      end
    end
        @user_images = user_images(session)
      erb :index
  end

  get '/images/:id/edit' do
    @collection_images = Image.all.select {|pic| pic.collection_id == session[:user_id]}
    @pic_id = params[:id]
    erb :delete_image
  end

  post '/process' do
    if params["delete_img"] != ""
      @image_id = params["delete_img"].to_i
      redirect "/images/#{@image_id}/edit"
    else
    idx1 = (params["source"])
    idx2 = (params["target"])
    Image.all.select {|image| image.public_id == params["source"]}
    source = cloud_search_public(idx1)
    target = cloud_search_public(idx2)
    binding.pry
    @compare = Image.process(source["resources"][0]["url"], target["resources"][0]["url"])
    erb :show_compare
    end
  end

  delete '/images/:id' do #delete action
    cloud_delete(params[:id])
    @image = Image.find_by_id(params[:id])
    @image.delete
    redirect to "/index/#{session[:user_id]}"
  end

end
