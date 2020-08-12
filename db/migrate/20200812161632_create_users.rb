class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :alias_name
      t.string :name
      t.text :avator
      t.integer :sex
      t.integer :sex_open_range
      t.integer :age
      t.string :age_open_range
      t.text :introduction
      t.string :snow_style
      t.string :play_style
      t.string :home_gelande
      t.string :email
      t.string :password_digest

      t.timestamps
    end
  end
end
