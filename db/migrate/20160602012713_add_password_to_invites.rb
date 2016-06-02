class AddPasswordToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :password, :string
  end
end
