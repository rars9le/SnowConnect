class ChangeDataAgeOpenRangeToUsers < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :age_open_range, :integer
  end
end
