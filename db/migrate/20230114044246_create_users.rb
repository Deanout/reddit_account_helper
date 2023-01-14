class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.references :account, null: true, foreign_key: true

      t.timestamps
    end
  end
end
