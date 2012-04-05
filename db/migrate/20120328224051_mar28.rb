class Mar28 < ActiveRecord::Migration
  def up
  	add_column :companies, :CIK, :string
  	add_column :companies, :ticker_symbol, :string
  	add_column :companies, :state, :string
  	add_column :companies, :zipcode, :string

  	add_column :users, :reset_password_expires, :datetime

    remove_column :secure_stats, :Operating_Income_Loss
    remove_column :secure_stats, :year
    remove_column :trade_stats, :year
    remove_column :users, :reset_password

    #User.create :email => "stat1@stattrader.com", :password => "1234", :activated => true, :subtype => 2

  	
  	# add to UI -
  	# weighted average shares outstanding
  	# depreciation and am
  end

  def down
  end
end
