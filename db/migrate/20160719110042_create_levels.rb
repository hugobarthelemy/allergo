class CreateLevels < ActiveRecord::Migration
  def change
    create_table :levels do |t|
      t.integer :allergy_level
      t.references :user, index: true, foreign_key: true
      t.references :allergy, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
