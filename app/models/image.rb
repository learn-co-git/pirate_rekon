require 'aws-sdk-rekognition'
require 'net/http'
require 'uri'
class Image < ActiveRecord::Base
  belongs_to :collection

  #this needs to be made secret for production
  Credentials = Aws::Credentials.new(
     'AKIA2MPVCMTYMIW5DK4A', 'khGL1/kfd76KmT2/FrJXHoxqM9kSjB75yQFJDjKQ')

  def open(url)
    Net::HTTP.get(URI.parse(url))
  end

  def self.process(source, target)
     client = Aws::Rekognition::Client.new credentials: Credentials

     file1 = open(source) {|f| f.read}
     file2 = open(target) {|f| f.read}

     resp = client.compare_faces({
       similarity_threshold: 90,
       source_image: {
         bytes: file1
       },
       target_image: {
         bytes: file2
       },
      })
  end

  def self.one_face(source)
    client = Aws::Rekognition::Client.new credentials: Credentials

    file1 = open(source) {|f| f.read}

    resp = client.detect_faces({
      image: {
        bytes: file1
      },
      attributes: ["ALL"]
    })
    resp
  end

  def self.pirate_rekon(source, target)
    diff = 0.03
    pos_counter = 0
    neg_counter = 0

      diff_bound_w = (source.box_width.to_f - target.box_width.to_f).abs()
      diff_bound_h = (source.box_height.to_f - target.box_height.to_f).abs()
      diff_bound_left = (source.box_left.to_f - target.box_left.to_f).abs()
      diff_bound_top = (source.box_top.to_f - target.box_top.to_f).abs()

          bound_diff = [diff_bound_w, diff_bound_h, diff_bound_left, diff_bound_top]

       age_low_bottom = source.age_low - 2
       age_low_top = source.age_low + 2

       age_high_bottom = source.age_high - 2
       age_high_top = source.age_high + 2

       if (age_low_bottom..age_low_top).include?(target.age_low) && (age_high_bottom..age_high_top).include?(target.age_high)
         pos_counter += 1
       end

       (pos_counter += 1) if source.eyeglasses == target.eyeglasses
       (neg_counter += 10) if source.eyeglasses != target.eyeglasses

       (pos_counter += 1) if (95..(99.9)).include?(source.eyeglass_con.to_f) && ((0.80)..(0.99)).include?(source.eyeglass_con.to_f)

       source.gender == target.gender ? (pos_counter += 1) : (neg_counter += 100) unless source.gender_con.to_f < 95 || target.gender_con.to_f < 95

       (pos_counter += 1) if source.beard == target.beard unless source.beard_con.to_f < 85 || target.beard_con.to_f < 85
       (neg_counter += 7) if source.beard != target.beard

       (pos_counter += 1) if source.mustache == target.mustache unless source.mustache_con.to_f < 90 || target.mustache_con.to_f < 90

          source_array = [source.eyeLeft,
            source.eyeRight,
            source.mouthLeft,
            source.mouthRight,
            source.nose,
            source.leftEyeBrowLeft,
            source.leftEyeBrowRight,
            source.leftEyeBrowUp,
            source.rightEyeBrowLeft,
            source.rightEyeBrowRight,
            source.rightEyeBrowUp,
            source.leftEyeLeft,
            source.leftEyeRight,
            source.leftEyeUp,
            source.leftEyeDown,
            source.rightEyeLeft,
            source.rightEyeRight,
            source.rightEyeUp,
            source.rightEyeDown,
            source.noseLeft,
            source.noseRight,
            source.mouthUp,
            source.mouthDown,
            source.leftPupil,
            source.rightPupil,
            source.upperJawlineLeft,
            source.midJawlineLeft,
            source.chinBottom,
            source.midJawlineRight,
            source.upperJawlineRight]

            source.brightness
            source.sharpness

            target_array = [target.eyeLeft,
              target.eyeRight,
              target.mouthLeft,
              target.mouthRight,
              target.nose,
              target.leftEyeBrowLeft,
              target.leftEyeBrowRight,
              target.leftEyeBrowUp,
              target.rightEyeBrowLeft,
              target.rightEyeBrowRight,
              target.rightEyeBrowUp,
              target.leftEyeLeft,
              target.leftEyeRight,
              target.leftEyeUp,
              target.leftEyeDown,
              target.rightEyeLeft,
              target.rightEyeRight,
              target.rightEyeUp,
              target.rightEyeDown,
              target.noseLeft,
              target.noseRight,
              target.mouthUp,
              target.mouthDown,
              target.leftPupil,
              target.rightPupil,
              target.upperJawlineLeft,
              target.midJawlineLeft,
              target.chinBottom,
              target.midJawlineRight,
              target.upperJawlineRight]

              bright = (source.brightness.to_f - target.brightness.to_f).abs()
              sharp = (source.sharpness.to_f - target.sharpness.to_f).abs()

              test = []
              (0...target_array.length).each do |i|
                pic1 = target_array[i].split("/")
                pic2 = source_array[i].split("/")
                val1 = ((pic1[0].to_f) - (pic2[0].to_f))
                val2 = ((pic1[1].to_f) - (pic2[1].to_f))
                pos_counter += 1 if val2.abs() < 0.043
                neg_counter += 2 if val2.abs() > 0.09
                pos_counter += 1 if val1.abs() < 0.1
                neg_counter += 2 if val1.abs() > 0.2
                test << [val1, val2]
              end

              analysis = {
                :bound_box => bound_diff,
                :bright_diff => bright,
                :sharp_diff => sharp,
              }

              if analysis[:sharp_diff] < 3
                pos_counter += 1
              elsif analysis[:sharp_diff] > 9
                neg_counter += 20
              end

              if analysis[:bright_diff] < 1
                pos_counter += 1
              elsif analysis[:bright_diff] > 2
                neg_counter += 5
              end


              if analysis[:bound_box][0] < 0.1
                pos_counter += 1
              end
              if analysis[:bound_box][0] > 0.2
                neg_counter += 4
              end
              if analysis[:bound_box][1] < 0.1
                pos_counter += 1
              end
              if analysis[:bound_box][1] > 0.2
                neg_counter += 4
              end
              if analysis[:bound_box][2] < 0.01
                pos_counter += 1
              end
              if analysis[:bound_box][2] > 0.02
                neg_counter += 4
              end
              if analysis[:bound_box][3] < 0.05
                pos_counter += 1
              end
              if analysis[:bound_box][3] > 0.1
                neg_counter += 4
              end

              result = [pos_counter, neg_counter]
                                                        #use id here, after....
              results = "BEGINNEW + #{result[0]} + '/' + #{result[1]} + '/' + #{target.name}"
              results
   end
end
