# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20200603195625) do

  create_table "collections", force: :cascade do |t|
    t.string   "name"
    t.datetime "creation_date"
    t.integer  "user_id"
    t.integer  "num_images"
  end

  create_table "images", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "creation_date"
    t.integer  "collection_id"
    t.string   "public_id"
    t.string   "box_width"
    t.string   "box_height"
    t.string   "box_left"
    t.string   "box_top"
    t.integer  "age_low"
    t.integer  "age_high"
    t.string   "eyeglasses"
    t.string   "eyeglass_con"
    t.string   "gender"
    t.string   "gender_con"
    t.string   "beard"
    t.string   "beard_con"
    t.string   "mustache"
    t.string   "mustache_con"
    t.string   "eyeLeft"
    t.string   "eyeRight"
    t.string   "mouthLeft"
    t.string   "mouthRight"
    t.string   "nose"
    t.string   "leftEyeBrowLeft"
    t.string   "leftEyeBrowRight"
    t.string   "leftEyeBrowUp"
    t.string   "rightEyeBrowLeft"
    t.string   "rightEyeBrowRight"
    t.string   "rightEyeBrowUp"
    t.string   "leftEyeLeft"
    t.string   "leftEyeRight"
    t.string   "leftEyeUp"
    t.string   "leftEyeDown"
    t.string   "rightEyeLeft"
    t.string   "rightEyeRight"
    t.string   "rightEyeUp"
    t.string   "rightEyeDown"
    t.string   "noseLeft"
    t.string   "noseRight"
    t.string   "mouthUp"
    t.string   "mouthDown"
    t.string   "leftPupil"
    t.string   "rightPupil"
    t.string   "upperJawlineLeft"
    t.string   "midJawlineLeft"
    t.string   "chinBottom"
    t.string   "midJawlineRight"
    t.string   "upperJawlineRight"
    t.string   "brightness"
    t.string   "sharpness"
    t.string   "compare_result"
    t.string   "label"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.string "email"
  end

end
