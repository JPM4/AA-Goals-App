class ChangeGoalsColumn < ActiveRecord::Migration
  def change
    remove_column :goals, :private
    add_column :goals, :priv, :boolean
  end
end
