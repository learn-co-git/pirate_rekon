class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
       t.string :name
       t.integer :user_id
       t.integer :collection_id
       t.datetime :creation_date
       t.binary :copy
     end
  end
end
