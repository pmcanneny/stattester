class April5 < ActiveRecord::Migration
  def up
  	#TODO: change country to string
  	#XML schema will be changed to make cob. integer
  	#change sic to be string
  	change_column :companies, :sic, :string
  	add_column :stat_filters, :company_id, :integer
  	change_column :stat_filters, :name, :string, :default => "default"
  	add_column :stat_filters, :user_type, :integer
  end

  def down
  end
end
