# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120321161640) do

  create_table "companies", :force => true do |t|
    t.string   "name",                                 :null => false
    t.integer  "user_id",                              :null => false
    t.integer  "combination",       :default => 2
    t.integer  "ownership"
    t.integer  "sic"
    t.integer  "country",           :default => 1
    t.integer  "region"
    t.boolean  "shifted",           :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "secure_now_id"
    t.integer  "secure_cy_id"
    t.integer  "secure_2y_id"
    t.integer  "secure_3y_id"
    t.integer  "secure_4y_id"
    t.integer  "secure_5y_id"
    t.integer  "trade_now_id"
    t.integer  "trade_cy_id"
    t.integer  "trade_2y_id"
    t.integer  "trade_3y_id"
    t.integer  "trade_4y_id"
    t.integer  "trade_5y_id"
    t.integer  "default_filter_id"
    t.boolean  "network_valid"
  end

  create_table "secure_stats", :force => true do |t|
    t.integer  "company_id",                                                                       :null => false
    t.integer  "gross_sales"
    t.integer  "assets"
    t.integer  "gross_profit"
    t.integer  "operating_profit"
    t.integer  "ebitda"
    t.decimal  "ebitda_multiple",                                   :precision => 10, :scale => 1
    t.decimal  "sales_multiple",                                    :precision => 10, :scale => 1
    t.decimal  "debt_multiple",                                     :precision => 10, :scale => 1
    t.decimal  "stock_price"
    t.integer  "reporting_scale"
    t.integer  "input_basis"
    t.integer  "quality"
    t.integer  "year"
    t.datetime "fye"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "Cash_Equivalents_and_Short_Term_Investments"
    t.integer  "Receivables_Net"
    t.integer  "Accounts_Receivable_Trade_Net"
    t.integer  "Other_Receivables"
    t.integer  "Inventories_Net"
    t.integer  "Inventories_Raw_Materials"
    t.integer  "Inventories_Work_in_Process"
    t.integer  "Inventories_Finished_Goods"
    t.integer  "Inventories_Supplies"
    t.integer  "Other_inventories"
    t.integer  "Prepaid_Expenses"
    t.integer  "Property_Plant_and_Equipment_Net"
    t.integer  "Property_Plant_and_Equipment_Gross"
    t.integer  "Land_Buildings_and_Improvements"
    t.integer  "Machinery_and_Equipment"
    t.integer  "Other_Components"
    t.integer  "Accumulated_Depreciation"
    t.integer  "Intangible_Assets_Net"
    t.integer  "Other_assets"
    t.integer  "Liabilities"
    t.integer  "Accounts_Payable_and_Accrued_Expenses"
    t.integer  "Accounts_Payable"
    t.integer  "Accuals_Other"
    t.integer  "Debt_and_Capital_Lease_Obligations_Current"
    t.integer  "Funded_Debt"
    t.integer  "Bank_Debt"
    t.integer  "Secured_Debt_Current"
    t.integer  "Line_of_Credit_Current"
    t.integer  "Secured_Long_Term"
    t.integer  "Line_of_Credit_Long_Term"
    t.integer  "Unsecured_Debt"
    t.integer  "Unsecured_Debt_Current"
    t.integer  "Unsecured_Debt_Long_Term"
    t.integer  "Mezzanine_Debt"
    t.integer  "Subordinated_Debt_Current"
    t.integer  "Subordinated_Debt_Long_Term"
    t.integer  "Convertible_Debt"
    t.integer  "Notes_Loans"
    t.integer  "Capital_Lease_Obligations"
    t.integer  "Commercial_Paper"
    t.integer  "Other_debts_liabilities"
    t.integer  "Equities"
    t.integer  "Sales_Revenue_Net"
    t.integer  "Revenue_from_Affiliates"
    t.integer  "Finance_Revenue"
    t.integer  "Other_Operating_Revenue"
    t.integer  "Other_revenues"
    t.integer  "Cost_of_Goods_and_Services_Sold"
    t.integer  "Cost_of_Goods_Sold"
    t.integer  "Cost_of_Goods_Sold_Direct_Materials"
    t.integer  "Cost_of_Goods_Sold_Direct_Labor"
    t.integer  "Cost_of_Goods_Sold_Overhead"
    t.integer  "Cost_of_Goods_Sold_Depreciation_and_Amortization"
    t.integer  "Cost_of_Goods_Sold_Other"
    t.integer  "Cost_of_Services"
    t.integer  "Cost_of_Services_Direct_Materials"
    t.integer  "Cost_of_Services_Direct_Labor"
    t.integer  "Cost_of_Services_Overhead"
    t.integer  "Cost_of_Services_Depreciation_and_Amortization"
    t.integer  "Cost_of_Services_Other"
    t.integer  "Other_Cost_of_Sales"
    t.integer  "Operating_Income_Loss"
    t.integer  "Expense"
    t.integer  "Selling_General_and_Administrative_Expenses"
    t.integer  "General_and_Administrative_Expenses"
    t.integer  "Labor_and_Related_Expenses"
    t.integer  "Salaries_and_Wages"
    t.integer  "Officers_Compensation"
    t.integer  "Postretirement_Benefit_Expense"
    t.integer  "Pension_and_Other_Employee_Benefit_Expense"
    t.integer  "Other_Labor_and_Related_Expenses"
    t.integer  "Other_Labor_unaccounted"
    t.integer  "Lease_and_Rental_Expense"
    t.integer  "Travel_and_Entertainment_Expense"
    t.integer  "General_and_Administrative_Expenses_Other"
    t.integer  "Other_G_A_unaccoutted"
    t.integer  "Selling_and_Marketing_Expenses"
    t.integer  "Selling_Expenses"
    t.integer  "Marketing_and_Advertising_Expenses"
    t.integer  "Other_selling_and_marketing_expenses"
    t.integer  "Research_and_Development_Expense"
    t.integer  "Depreciation_and_Amortization"
    t.integer  "Provision_for_Doubtful_Accounts"
    t.integer  "Other_operating_expenses"
    t.integer  "Depreciation_and_Amortization_Total"
    t.integer  "Depreciation_Non_Production"
    t.integer  "Amortization_Intangibles_Non_Productive"
    t.integer  "Amortization_Acquisition_Costs"
    t.integer  "Depreciation_and_Amortization_Other_Unspecified"
    t.integer  "Weighted_Average_Shares_Outstanding_Fully_Diluted"
    t.integer  "Equity_Valuation"
    t.integer  "Assets_Valuation"
    t.integer  "Enterprise_Book_Value"
    t.integer  "Enterprise_Market_Valuation"
  end

  create_table "stat_filters", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "combination"
    t.integer  "ownership"
    t.integer  "sic_low"
    t.integer  "sic_high"
    t.integer  "country"
    t.integer  "region"
    t.integer  "revenue_low"
    t.integer  "revenue_high"
    t.integer  "asset_low"
    t.integer  "asset_high"
    t.integer  "input_basis"
    t.integer  "quality"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trade_stats", :force => true do |t|
    t.integer  "company_id",                                             :null => false
    t.integer  "revenue_category"
    t.integer  "asset_category"
    t.decimal  "sales_growth",            :precision => 10, :scale => 1
    t.decimal  "gross_profit_margin",     :precision => 10, :scale => 1
    t.decimal  "operating_profit_margin", :precision => 10, :scale => 1
    t.decimal  "ebitda_percent",          :precision => 10, :scale => 1
    t.decimal  "enterprise_multiple",     :precision => 10, :scale => 1
    t.decimal  "ebitda_multiple",         :precision => 10, :scale => 1
    t.decimal  "sales_multiple",          :precision => 10, :scale => 1
    t.decimal  "debt_multiple",           :precision => 10, :scale => 1
    t.integer  "input_basis"
    t.integer  "quality"
    t.integer  "year"
    t.datetime "fye"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                    :null => false
    t.string   "password_digest",                          :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "activated",             :default => false
    t.string   "activation_code"
    t.datetime "last_activation_email"
    t.datetime "last_password_email"
    t.integer  "type"
    t.integer  "subtype"
    t.string   "auth_token"
    t.boolean  "reset_password",        :default => false
    t.string   "reset_password_code"
  end

end
