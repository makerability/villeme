class CreateTips < ActiveRecord::Migration
  def change
    create_table :tips do |t|
      t.text :description
      t.references :events, index: true

      t.timestamps
    end
  end
end
