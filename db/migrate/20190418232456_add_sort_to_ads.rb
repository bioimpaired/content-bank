class AddSortToAds < ActiveRecord::Migration[5.2]
  def change
    add_column :ads, :sort, :integer
  end
end
