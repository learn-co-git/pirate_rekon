class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.string :name
      t.datetime :creation_date
      t.integer :user_id
      t.integer :num_images
    end
  end
end
