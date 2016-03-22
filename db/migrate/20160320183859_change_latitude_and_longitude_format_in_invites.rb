class ChangeLatitudeAndLongitudeFormatInInvites < ActiveRecord::Migration
  def change
    change_column :invites, :latitude, :float
    change_column :invites, :longitude, :float
  end
end
