class CreateRatings < ActiveRecord::Migration[4.2]
  def change
    create_table :ratings do |t|
      t.integer :value
      t.integer :user_id
      t.integer :book_id
    end
  end
end
