class CreateAds < ActiveRecord::Migration[5.2]
  def change
    create_table :ads do |t|
      t.string :title
      t.integer :brand_id
      t.integer :country_id

      t.timestamps
    end
  end
end
