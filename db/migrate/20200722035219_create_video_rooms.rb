class CreateVideoRooms < ActiveRecord::Migration[6.0]
  def change
    create_table :video_rooms do |t|

      t.timestamps
    end
  end
end
