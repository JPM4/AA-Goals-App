class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.integer :user_id, null: false
      t.text :body, null: false
      t.boolean :private, null: false

      t.timestamps null: false
    end
    add_index :goals, :user_id
  end
end
