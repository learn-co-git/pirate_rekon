class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
       t.string :name
       t.string :url
       t.datetime :creation_date
       t.integer :collection_id
       t.string :public_id
     end
  end
end
