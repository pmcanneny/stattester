class AddIndexes < ActiveRecord::Migration
  def up
  	add_index :companies, :secure_now_id
  	add_index :companies, :secure_cy_id
  	add_index :companies, :secure_2y_id
  	add_index :companies, :secure_3y_id
  	add_index :companies, :secure_4y_id
  	add_index :companies, :secure_5y_id
  	add_index :companies, :trade_now_id
  	add_index :companies, :trade_cy_id
  	add_index :companies, :trade_2y_id
  	add_index :companies, :trade_3y_id
  	add_index :companies, :trade_4y_id
  	add_index :companies, :trade_5y_id

  	add_index :companies, :user_id
  	add_index :companies, :current_filter_id

  	add_index :trade_stats, :company_id
  	add_index :secure_stats, :company_id

  	add_index :stat_filters, :company_id


  end

  def down
  end
end
