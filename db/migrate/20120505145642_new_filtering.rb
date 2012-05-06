class NewFiltering < ActiveRecord::Migration
  def up
  	remove_column :stat_filters, :sic_low
  	remove_column :stat_filters, :sic_high
  	remove_column :stat_filters, :ownership
  	remove_column :stat_filters, :combination
  	remove_column :stat_filters, :input_basis
  	remove_column :stat_filters, :quality
  	remove_column :stat_filters, :user_type

  	add_column :stat_filters, :sic_parent, :string
    add_column :stat_filters, :sic_level1, :string
    add_column :stat_filters, :sic_level2, :string
    add_column :stat_filters, :sic_level3, :string
    add_column :stat_filters, :sic_level4, :string
  	add_column :stat_filters, :accounts_audit, :boolean, :default => true
  	add_column :stat_filters, :accounts_review, :boolean, :default => true
  	add_column :stat_filters, :accounts_mgt, :boolean, :default => true
  	add_column :stat_filters, :user_cpa, :boolean, :default => true
  	add_column :stat_filters, :user_investment_banker, :boolean, :default => true
  	add_column :stat_filters, :user_business_broker, :boolean, :default => true
  	add_column :stat_filters, :user_business_appraiser, :boolean, :default => true
  	add_column :stat_filters, :user_commercial_lender, :boolean, :default => true
  	add_column :stat_filters, :user_private_investor, :boolean, :default => true
  	add_column :stat_filters, :user_public_investor, :boolean, :default => true
  	add_column :stat_filters, :user_financial_pro, :boolean, :default => true
  	add_column :stat_filters, :user_executive, :boolean, :default => true
  	add_column :stat_filters, :user_attorney, :boolean, :default => true
  	add_column :stat_filters, :user_consultant, :boolean, :default => true
  	add_column :stat_filters, :user_not_classified, :boolean, :default => true
    add_column :stat_filters, :user_stattrader, :boolean, :default => true
  	add_column :stat_filters, :entities_combination, :boolean, :default => true
  	add_column :stat_filters, :entities_not_combination, :boolean, :default => true
  	add_column :stat_filters, :ownership_public, :boolean, :default => true
  	add_column :stat_filters, :ownership_private_investor, :boolean, :default => true
  	add_column :stat_filters, :ownership_private_operator, :boolean, :default => true
  	add_column :stat_filters, :ownership_division, :boolean, :default => true

  end

  def down
  end
end
