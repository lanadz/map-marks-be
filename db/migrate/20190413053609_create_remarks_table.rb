class CreateRemarksTable < ActiveRecord::Migration[5.2]
  def change
    create_table :remarks do |t|
      t.string :user_name
      t.text :body
      t.st_point :point, geographic: true

      t.timestamps
    end

    add_index :remarks, :point, using: :gist
  end
end
