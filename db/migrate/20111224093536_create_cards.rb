class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.integer :user_id
      t.integer :day
      t.integer :month
      t.integer :year
      t.text :entry

      t.timestamps
    end
  end
end
