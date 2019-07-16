class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.integer :type, null: false
      t.string :sub_type
      t.string :merchant
      t.float :change, null: false
      t.integer :currency, default: 0
      t.text :comments
      t.datetime :datetime, null: false

      t.timestamps
    end
  end
end
