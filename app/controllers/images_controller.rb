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
       land = pic.face_details[0].landmarks
       qual = pic.face_details[0].quality
       new_image = Image.new(:name => file[i]["filename"], :url => file[i]["url"], :creation_date => Time.now, :collection_id => session[:user_id], :public_id => file[i]["public_id"], :box_width => det.bounding_box.width.to_s, :box_height => det.bounding_box.height.to_s, :box_left => det.bounding_box.left.to_s, :box_top => det.bounding_box.top.to_s, :age_low => det.age_range.low, :age_high => det.age_range.high, :eyeglasses => det.eyeglasses.value, :eyeglass_con => det.eyeglasses.confidence.to_s, :gender => det.gender.value, :gender_con => det.gender.confidence.to_s, :beard => det.beard.value, :beard_con => det.beard.confidence.to_s, :mustache => det.mustache.value, :mustache_con => det.mustache.confidence.to_s, :eyeLeft => (land[0].x.to_s + '/' + land[0].y.to_s), :eyeRight => (land[1].x.to_s + '/' + land[1].y.to_s), :mouthLeft => (land[2].x.to_s + '/' + land[2].y.to_s), :mouthRight => (land[3].x.to_s + '/' + land[3].y.to_s), :nose => (land[4].x.to_s + '/' + land[4].y.to_s), :leftEyeBrowLeft => (land[5].x.to_s + '/' + land[5].y.to_s), :leftEyeBrowRight => (land[6].x.to_s + '/' + land[6].y.to_s), :leftEyeBrowUp => (land[7].x.to_s + '/' + land[7].y.to_s), :rightEyeBrowLeft => (land[8].x.to_s + '/' + land[8].y.to_s), :rightEyeBrowRight => (land[9].x.to_s + '/' + land[9].y.to_s), :rightEyeBrowUp => (land[10].x.to_s + '/' + land[10].y.to_s), :leftEyeLeft => (land[11].x.to_s + '/' + land[11].y.to_s), :leftEyeRight => (land[12].x.to_s + '/' + land[12].y.to_s), :leftEyeUp => (land[13].x.to_s + '/' + land[13].y.to_s), :leftEyeDown => (land[14].x.to_s + '/' + land[14].y.to_s), :rightEyeLeft => (land[15].x.to_s + '/' + land[15].y.to_s), :rightEyeRight => (land[16].x.to_s + '/' + land[16].y.to_s), :rightEyeUp => (land[17].x.to_s + '/' + land[17].y.to_s), :rightEyeDown => (land[18].x.to_s + '/' + land[18].y.to_s), :noseLeft => (land[19].x.to_s + '/' + land[19].y.to_s), :noseRight => (land[20].x.to_s + '/' + land[20].y.to_s), :mouthUp => (land[21].x.to_s + '/' + land[21].y.to_s), :mouthDown => (land[22].x.to_s + '/' + land[22].y.to_s), :leftPupil => (land[23].x.to_s + '/' + land[23].y.to_s), :rightPupil => (land[24].x.to_s + '/' + land[24].y.to_s), :upperJawlineLeft => (land[25].x.to_s + '/' + land[25].y.to_s), :midJawlineLeft => (land[26].x.to_s + '/' + land[26].y.to_s), :chinBottom => (land[27].x.to_s + '/' + land[27].y.to_s), :midJawlineRight => (land[28].x.to_s + '/' + land[28].y.to_s), :upperJawlineRight => (land[29].x.to_s + '/' + land[29].y.to_s), :brightness => qual.brightness, :sharpness => qual.sharpness, :compare_result => "", :label => "")
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
     @source = Image.find_by(:name[params["soft"]])
     Image.all.each do |target|
       if target != @source
       @array << Image.pirate_rekon(@source, target)
      end
     end
   end
    simple_array = []
   @array.each do |file|
     simple_array << file[8...file.length]
    end
   @image = Image.find_by_id(@source.id) #this is technically an update
   @image.compare_result = @array.join() # but non-user initiated
   @image.save
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
