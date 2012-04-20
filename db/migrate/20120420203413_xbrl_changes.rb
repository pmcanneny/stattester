class XbrlChanges < ActiveRecord::Migration
  def up
  	change_column :companies, :country, :string, :default => "USA"
  	change_column :secure_stats, :fye, :date
  	add_column :secure_stats, :xbrlfile, :text
  	change_column :secure_stats, :ebitda_multiple, :decimal, :precision => 10, :scale => 2
    change_column :secure_stats, :sales_multiple, :decimal, :precision => 10, :scale => 2
    change_column :secure_stats, :debt_multiple, :decimal, :precision => 10, :scale => 2
    change_column :secure_stats, :stock_price, :decimal, :precision => 10, :scale => 2


		change_column :secure_stats, :gross_sales, :integer, :limit => 8
		change_column :secure_stats, :assets, :integer, :limit => 8
		change_column :secure_stats, :gross_profit, :integer, :limit => 8
		change_column :secure_stats, :operating_profit, :integer, :limit => 8
		change_column :secure_stats, :ebitda, :integer, :limit => 8
		change_column :secure_stats, :reporting_scale, :integer, :limit => 8
		change_column :secure_stats, :input_basis, :integer, :limit => 8
		change_column :secure_stats, :quality, :integer, :limit => 8
		change_column :secure_stats, :Cash_Equivalents_and_Short_Term_Investments, :integer, :limit => 8
		change_column :secure_stats, :Receivables_Net, :integer, :limit => 8
		change_column :secure_stats, :Accounts_Receivable_Trade_Net, :integer, :limit => 8
		change_column :secure_stats, :Other_Receivables, :integer, :limit => 8
		change_column :secure_stats, :Inventories_Net, :integer, :limit => 8
		change_column :secure_stats, :Inventories_Raw_Materials, :integer, :limit => 8
		change_column :secure_stats, :Inventories_Work_in_Process, :integer, :limit => 8
		change_column :secure_stats, :Inventories_Finished_Goods, :integer, :limit => 8
		change_column :secure_stats, :Inventories_Supplies, :integer, :limit => 8
		change_column :secure_stats, :Other_inventories, :integer, :limit => 8
		change_column :secure_stats, :Prepaid_Expenses, :integer, :limit => 8
		change_column :secure_stats, :Property_Plant_and_Equipment_Net, :integer, :limit => 8
		change_column :secure_stats, :Property_Plant_and_Equipment_Gross, :integer, :limit => 8
		change_column :secure_stats, :Land_Buildings_and_Improvements, :integer, :limit => 8
		change_column :secure_stats, :Machinery_and_Equipment, :integer, :limit => 8
		change_column :secure_stats, :Other_Components, :integer, :limit => 8
		change_column :secure_stats, :Accumulated_Depreciation, :integer, :limit => 8
		change_column :secure_stats, :Intangible_Assets_Net, :integer, :limit => 8
		change_column :secure_stats, :Other_assets, :integer, :limit => 8
		change_column :secure_stats, :Liabilities, :integer, :limit => 8
		change_column :secure_stats, :Accounts_Payable_and_Accrued_Expenses, :integer, :limit => 8
		change_column :secure_stats, :Accounts_Payable, :integer, :limit => 8
		change_column :secure_stats, :Accuals_Other, :integer, :limit => 8
		change_column :secure_stats, :Debt_and_Capital_Lease_Obligations_Current, :integer, :limit => 8
		change_column :secure_stats, :Funded_Debt, :integer, :limit => 8
		change_column :secure_stats, :Bank_Debt, :integer, :limit => 8
		change_column :secure_stats, :Secured_Debt_Current, :integer, :limit => 8
		change_column :secure_stats, :Line_of_Credit_Current, :integer, :limit => 8
		change_column :secure_stats, :Secured_Long_Term, :integer, :limit => 8
		change_column :secure_stats, :Line_of_Credit_Long_Term, :integer, :limit => 8
		change_column :secure_stats, :Unsecured_Debt, :integer, :limit => 8
		change_column :secure_stats, :Unsecured_Debt_Current, :integer, :limit => 8
		change_column :secure_stats, :Unsecured_Debt_Long_Term, :integer, :limit => 8
		change_column :secure_stats, :Mezzanine_Debt, :integer, :limit => 8
		change_column :secure_stats, :Subordinated_Debt_Current, :integer, :limit => 8
		change_column :secure_stats, :Subordinated_Debt_Long_Term, :integer, :limit => 8
		change_column :secure_stats, :Convertible_Debt, :integer, :limit => 8
		change_column :secure_stats, :Notes_Loans, :integer, :limit => 8
		change_column :secure_stats, :Capital_Lease_Obligations, :integer, :limit => 8
		change_column :secure_stats, :Commercial_Paper, :integer, :limit => 8
		change_column :secure_stats, :Other_debts_liabilities, :integer, :limit => 8
		change_column :secure_stats, :Equities, :integer, :limit => 8
		change_column :secure_stats, :Sales_Revenue_Net, :integer, :limit => 8
		change_column :secure_stats, :Revenue_from_Affiliates, :integer, :limit => 8
		change_column :secure_stats, :Finance_Revenue, :integer, :limit => 8
		change_column :secure_stats, :Other_Operating_Revenue, :integer, :limit => 8
		change_column :secure_stats, :Other_revenues, :integer, :limit => 8
		change_column :secure_stats, :Cost_of_Goods_and_Services_Sold, :integer, :limit => 8
		change_column :secure_stats, :Cost_of_Goods_Sold, :integer, :limit => 8
		change_column :secure_stats, :Cost_of_Goods_Sold_Direct_Materials, :integer, :limit => 8
		change_column :secure_stats, :Cost_of_Goods_Sold_Direct_Labor, :integer, :limit => 8
		change_column :secure_stats, :Cost_of_Goods_Sold_Overhead, :integer, :limit => 8
		change_column :secure_stats, :Cost_of_Goods_Sold_Depreciation_and_Amortization, :integer, :limit => 8
		change_column :secure_stats, :Cost_of_Goods_Sold_Other, :integer, :limit => 8
		change_column :secure_stats, :Cost_of_Services, :integer, :limit => 8
		change_column :secure_stats, :Cost_of_Services_Direct_Materials, :integer, :limit => 8
		change_column :secure_stats, :Cost_of_Services_Direct_Labor, :integer, :limit => 8
		change_column :secure_stats, :Cost_of_Services_Overhead, :integer, :limit => 8
		change_column :secure_stats, :Cost_of_Services_Depreciation_and_Amortization, :integer, :limit => 8
		change_column :secure_stats, :Cost_of_Services_Other, :integer, :limit => 8
		change_column :secure_stats, :Other_Cost_of_Sales, :integer, :limit => 8
		change_column :secure_stats, :Expense, :integer, :limit => 8
		change_column :secure_stats, :Selling_General_and_Administrative_Expenses, :integer, :limit => 8
		change_column :secure_stats, :General_and_Administrative_Expenses, :integer, :limit => 8
		change_column :secure_stats, :Labor_and_Related_Expenses, :integer, :limit => 8
		change_column :secure_stats, :Salaries_and_Wages, :integer, :limit => 8
		change_column :secure_stats, :Officers_Compensation, :integer, :limit => 8
		change_column :secure_stats, :Postretirement_Benefit_Expense, :integer, :limit => 8
		change_column :secure_stats, :Pension_and_Other_Employee_Benefit_Expense, :integer, :limit => 8
		change_column :secure_stats, :Other_Labor_and_Related_Expenses, :integer, :limit => 8
		change_column :secure_stats, :Other_Labor_unaccounted, :integer, :limit => 8
		change_column :secure_stats, :Lease_and_Rental_Expense, :integer, :limit => 8
		change_column :secure_stats, :Travel_and_Entertainment_Expense, :integer, :limit => 8
		change_column :secure_stats, :General_and_Administrative_Expenses_Other, :integer, :limit => 8
		change_column :secure_stats, :Other_G_A_unaccoutted, :integer, :limit => 8
		change_column :secure_stats, :Selling_and_Marketing_Expenses, :integer, :limit => 8
		change_column :secure_stats, :Selling_Expenses, :integer, :limit => 8
		change_column :secure_stats, :Marketing_and_Advertising_Expenses, :integer, :limit => 8
		change_column :secure_stats, :Other_selling_and_marketing_expenses, :integer, :limit => 8
		change_column :secure_stats, :Research_and_Development_Expense, :integer, :limit => 8
		change_column :secure_stats, :Depreciation_and_Amortization, :integer, :limit => 8
		change_column :secure_stats, :Provision_for_Doubtful_Accounts, :integer, :limit => 8
		change_column :secure_stats, :Other_operating_expenses, :integer, :limit => 8
		change_column :secure_stats, :Depreciation_and_Amortization_Total, :integer, :limit => 8
		change_column :secure_stats, :Depreciation_Non_Production, :integer, :limit => 8
		change_column :secure_stats, :Amortization_Intangibles_Non_Productive, :integer, :limit => 8
		change_column :secure_stats, :Amortization_Acquisition_Costs, :integer, :limit => 8
		change_column :secure_stats, :Depreciation_and_Amortization_Other_Unspecified, :integer, :limit => 8
		change_column :secure_stats, :Weighted_Average_Shares_Outstanding_Fully_Diluted, :integer, :limit => 8
		change_column :secure_stats, :Equity_Valuation, :integer, :limit => 8
		change_column :secure_stats, :Assets_Valuation, :integer, :limit => 8
		change_column :secure_stats, :Enterprise_Book_Value, :integer, :limit => 8
		change_column :secure_stats, :Enterprise_Market_Valuation, :integer, :limit => 8
  end

  def down
  end
end
