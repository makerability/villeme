class RemoveColumnNameFromPersona < ActiveRecord::Migration
  def change
    remove_column :personas, :name
  end
end
