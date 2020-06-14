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
       pic = Image.one_face(file[i]["url"])
       det = pic.face_details[0]

       new_image = Image.new(:name => file[i]["filename"], :url => file[i]["url"], :creation_date => Time.now, :collection_id => session[:user_id], :public_id => file[i]["public_id"],
       :box_width => det.bounding_box.width, :box_height => det.bounding_box.height, :box_left => det.bounding_box.left, :box_top => det.bounding_box.top, :age_low => det.age_range.low, :age_high => det.age_range.high, :eyeglasses => det.eyeglasses.value, :eyeglasses_con => det.eyeglasses.confidence, :gender => det.gender.value, :gender_con => det.gender.confidence, :beard => det.beard.value, :beard_con => det.beard.confidence, :mustache => det.mustache.value, :mustache_con => det.mustache.confidence, :eyeLeft => , :eyeRight => , :mouthLeft =>  , :mouthRight => , :nose => , :leftEyeBrowLeft => , :leftEyeBrowRight => , :leftEyeBrowUp , :rightEyeBrowLeft => , :rightEyeBrowRight => , :rightEyeBrowUp => , :leftEyeLeft => , :leftEyeRight , :leftEyeUp => , :leftEyeDown , :rightEyeLeft , :rightEyeRight , :rightEyeUp => , :rightEyeDown , :noseLeft => , :noseRight => , :mouthUp => , :mouthDown => , :leftPupil => , :rightPupil => ,:upperJawlineLeft => , :midJawlineLeft => , :chinBottom => , :midJawlineRight => , :upperJawlineRight => , :brightness => , :sharpness => , :compare_result => , :label => )
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
   elsif params[:source] != ""
     idx1 = (params["source"])
     idx2 = (params["target"])
     Image.all.select {|image| image.public_id == params["source"]}
     source = cloud_search_public(idx1)
     target = cloud_search_public(idx2)
     @compare = Image.process(source["resources"][0]["url"], target["resources"][0]["url"])
   elsif params["soft"] != ""
     @array = []
     @source = params[:soft]
     Images.all.each do |target|
       @array << Image.pirate_rekon(@source, target)
     end
   end
   redirect "/show/results/#{@source.id}"
 end

 get "/show/results/:id" do
   erb :show_compare
 end

 delete '/images/:id' do #delete action
   cloud_delete(params[:id])
   @image = Image.find_by_id(params[:id])
   @image.delete
   redirect to "/index/#{session[:user_id]}"
 end

end
