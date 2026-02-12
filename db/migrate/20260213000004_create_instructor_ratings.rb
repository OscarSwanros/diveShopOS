# frozen_string_literal: true

class CreateInstructorRatings < ActiveRecord::Migration[8.1]
  def change
    create_table :instructor_ratings, id: :string do |t|
      t.references :user, null: false, foreign_key: true, type: :string
      t.string :agency, null: false
      t.string :rating_level, null: false
      t.string :rating_number
      t.boolean :active, default: true, null: false
      t.date :expiration_date

      t.timestamps
    end

    add_index :instructor_ratings, [ :user_id, :agency, :rating_level ], unique: true,
      name: "index_instructor_ratings_on_user_agency_level"
  end
end
