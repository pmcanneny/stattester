#add columns to ensure no email spam requests
#add more secure stat fields
#add user types, company valid check, forgot password fields
#add column for user security token

class Updates < ActiveRecord::Migration
  def up
  	change_column :users, :activation_code, :string

  	add_column :users, :last_activation_email, :datetime
  	add_column :users, :last_password_email, :datetime
  	add_column :users, :type, :integer
  	add_column :users, :subtype, :integer
  	add_column :companies, :network_valid, :boolean

  	add_column :users, :auth_token, :string

  	add_column :users, :reset_password, :boolean, :default => false
  	add_column :users, :reset_password_code, :string

  	add_column :secure_stats, :Cash_Equivalents_and_Short_Term_Investments, :integer
	add_column :secure_stats, :Receivables_Net, :integer
	add_column :secure_stats, :Accounts_Receivable_Trade_Net, :integer
	add_column :secure_stats, :Other_Receivables, :integer
	add_column :secure_stats, :Inventories_Net, :integer
	add_column :secure_stats, :Inventories_Raw_Materials, :integer
	add_column :secure_stats, :Inventories_Work_in_Process, :integer
	add_column :secure_stats, :Inventories_Finished_Goods, :integer
	add_column :secure_stats, :Inventories_Supplies, :integer
	add_column :secure_stats, :Other_inventories, :integer
	add_column :secure_stats, :Prepaid_Expenses, :integer
	add_column :secure_stats, :Property_Plant_and_Equipment_Net, :integer
	add_column :secure_stats, :Property_Plant_and_Equipment_Gross, :integer
	add_column :secure_stats, :Land_Buildings_and_Improvements, :integer
	add_column :secure_stats, :Machinery_and_Equipment, :integer
	add_column :secure_stats, :Other_Components, :integer
	add_column :secure_stats, :Accumulated_Depreciation, :integer
	add_column :secure_stats, :Intangible_Assets_Net, :integer
	add_column :secure_stats, :Other_assets, :integer
	add_column :secure_stats, :Liabilities, :integer
	add_column :secure_stats, :Accounts_Payable_and_Accrued_Expenses, :integer
	add_column :secure_stats, :Accounts_Payable, :integer
	add_column :secure_stats, :Accuals_Other, :integer
	add_column :secure_stats, :Debt_and_Capital_Lease_Obligations_Current, :integer
	add_column :secure_stats, :Funded_Debt, :integer
	add_column :secure_stats, :Bank_Debt, :integer
	add_column :secure_stats, :Secured_Debt_Current, :integer
	add_column :secure_stats, :Line_of_Credit_Current, :integer
	add_column :secure_stats, :Secured_Long_Term, :integer
	add_column :secure_stats, :Line_of_Credit_Long_Term, :integer
	add_column :secure_stats, :Unsecured_Debt, :integer
	add_column :secure_stats, :Unsecured_Debt_Current, :integer
	add_column :secure_stats, :Unsecured_Debt_Long_Term, :integer
	add_column :secure_stats, :Mezzanine_Debt, :integer
	add_column :secure_stats, :Subordinated_Debt_Current, :integer
	add_column :secure_stats, :Subordinated_Debt_Long_Term, :integer
	add_column :secure_stats, :Convertible_Debt, :integer
	add_column :secure_stats, :Notes_Loans, :integer
	#add_column :secure_stats, :Notes_Loans, :integer
	#add_column :secure_stats, :Notes_Loans, :integer
	add_column :secure_stats, :Capital_Lease_Obligations, :integer
	#add_column :secure_stats, :Capital_Lease_Obligations, :integer
	#add_column :secure_stats, :Capital_Lease_Obligations, :integer
	add_column :secure_stats, :Commercial_Paper, :integer
	add_column :secure_stats, :Other_debts_liabilities, :integer
	add_column :secure_stats, :Equities, :integer
	add_column :secure_stats, :Sales_Revenue_Net, :integer
	add_column :secure_stats, :Revenue_from_Affiliates, :integer
	add_column :secure_stats, :Finance_Revenue, :integer
	add_column :secure_stats, :Other_Operating_Revenue, :integer
	add_column :secure_stats, :Other_revenues, :integer
	add_column :secure_stats, :Cost_of_Goods_and_Services_Sold, :integer
	add_column :secure_stats, :Cost_of_Goods_Sold, :integer
	add_column :secure_stats, :Cost_of_Goods_Sold_Direct_Materials, :integer
	add_column :secure_stats, :Cost_of_Goods_Sold_Direct_Labor, :integer
	add_column :secure_stats, :Cost_of_Goods_Sold_Overhead, :integer
	add_column :secure_stats, :Cost_of_Goods_Sold_Depreciation_and_Amortization, :integer
	add_column :secure_stats, :Cost_of_Goods_Sold_Other, :integer
	add_column :secure_stats, :Cost_of_Services, :integer
	add_column :secure_stats, :Cost_of_Services_Direct_Materials, :integer
	add_column :secure_stats, :Cost_of_Services_Direct_Labor, :integer
	add_column :secure_stats, :Cost_of_Services_Overhead, :integer
	add_column :secure_stats, :Cost_of_Services_Depreciation_and_Amortization, :integer
	add_column :secure_stats, :Cost_of_Services_Other, :integer
	add_column :secure_stats, :Other_Cost_of_Sales, :integer
	add_column :secure_stats, :Operating_Income_Loss, :integer
	add_column :secure_stats, :Expense, :integer
	add_column :secure_stats, :Selling_General_and_Administrative_Expenses, :integer
	add_column :secure_stats, :General_and_Administrative_Expenses, :integer
	add_column :secure_stats, :Labor_and_Related_Expenses, :integer
	add_column :secure_stats, :Salaries_and_Wages, :integer
	add_column :secure_stats, :Officers_Compensation, :integer
	add_column :secure_stats, :Postretirement_Benefit_Expense, :integer
	add_column :secure_stats, :Pension_and_Other_Employee_Benefit_Expense, :integer
	add_column :secure_stats, :Other_Labor_and_Related_Expenses, :integer
	add_column :secure_stats, :Other_Labor_unaccounted, :integer
	add_column :secure_stats, :Lease_and_Rental_Expense, :integer
	add_column :secure_stats, :Travel_and_Entertainment_Expense, :integer
	add_column :secure_stats, :General_and_Administrative_Expenses_Other, :integer
	add_column :secure_stats, :Other_G_A_unaccoutted, :integer
	add_column :secure_stats, :Selling_and_Marketing_Expenses, :integer
	add_column :secure_stats, :Selling_Expenses, :integer
	add_column :secure_stats, :Marketing_and_Advertising_Expenses, :integer
	add_column :secure_stats, :Other_selling_and_marketing_expenses, :integer
	add_column :secure_stats, :Research_and_Development_Expense, :integer
	add_column :secure_stats, :Depreciation_and_Amortization, :integer
	add_column :secure_stats, :Provision_for_Doubtful_Accounts, :integer
	add_column :secure_stats, :Other_operating_expenses, :integer
	add_column :secure_stats, :Depreciation_and_Amortization_Total, :integer
	#add_column :secure_stats, :Cost_of_Goods_Sold_Depreciation_and_Amortization, :integer
	#add_column :secure_stats, :Cost_of_Services_Depreciation_and_Amortization, :integer
	add_column :secure_stats, :Depreciation_Non_Production, :integer
	add_column :secure_stats, :Amortization_Intangibles_Non_Productive, :integer
	add_column :secure_stats, :Amortization_Acquisition_Costs, :integer
	add_column :secure_stats, :Depreciation_and_Amortization_Other_Unspecified, :integer
	add_column :secure_stats, :Weighted_Average_Shares_Outstanding_Fully_Diluted, :integer
	add_column :secure_stats, :Equity_Valuation, :integer
	add_column :secure_stats, :Assets_Valuation, :integer
	add_column :secure_stats, :Enterprise_Book_Value, :integer
	add_column :secure_stats, :Enterprise_Market_Valuation, :integer
  end

end
