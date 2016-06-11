class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.belongs_to :product
      t.string :name, null: false
      t.text :description, null: false
      t.string :data_content_id, null: false

      t.timestamps null: false
    end

    add_index :reviews, :data_content_id, unique: true
  end
end
