class AddAllYearToItems < ActiveRecord::Migration
  def change
    add_column :items, :all_year, :boolean, default: false
  end
end
