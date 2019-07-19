class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :password, null: false
      t.string :token
      t.string :avatar

      t.timestamps
    end
  end
end
