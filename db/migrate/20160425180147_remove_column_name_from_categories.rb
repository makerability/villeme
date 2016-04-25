class RemoveColumnNameFromCategories < ActiveRecord::Migration
  def change
    remove_column :categories, :name
  end
end
