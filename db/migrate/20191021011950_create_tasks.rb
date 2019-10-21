class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.text :content
      t.references :todo, foreign_key: true
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
