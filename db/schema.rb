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

ActiveRecord::Schema.define(:version => 20120506183130) do

  create_table "companies", :force => true do |t|
    t.string   "name",                                 :null => false
    t.integer  "user_id",                              :null => false
    t.integer  "combination",       :default => 2
    t.integer  "ownership"
    t.string   "sic"
    t.string   "country",           :default => "USA"
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
    t.integer  "current_filter_id"
    t.boolean  "network_valid"
    t.string   "CIK"
    t.string   "ticker_symbol"
    t.string   "state"
    t.string   "zipcode"
  end

  add_index "companies", ["current_filter_id"], :name => "index_companies_on_current_filter_id"
  add_index "companies", ["secure_2y_id"], :name => "index_companies_on_secure_2y_id"
  add_index "companies", ["secure_3y_id"], :name => "index_companies_on_secure_3y_id"
  add_index "companies", ["secure_4y_id"], :name => "index_companies_on_secure_4y_id"
  add_index "companies", ["secure_5y_id"], :name => "index_companies_on_secure_5y_id"
  add_index "companies", ["secure_cy_id"], :name => "index_companies_on_secure_cy_id"
  add_index "companies", ["secure_now_id"], :name => "index_companies_on_secure_now_id"
  add_index "companies", ["trade_2y_id"], :name => "index_companies_on_trade_2y_id"
  add_index "companies", ["trade_3y_id"], :name => "index_companies_on_trade_3y_id"
  add_index "companies", ["trade_4y_id"], :name => "index_companies_on_trade_4y_id"
  add_index "companies", ["trade_5y_id"], :name => "index_companies_on_trade_5y_id"
  add_index "companies", ["trade_cy_id"], :name => "index_companies_on_trade_cy_id"
  add_index "companies", ["trade_now_id"], :name => "index_companies_on_trade_now_id"
  add_index "companies", ["user_id"], :name => "index_companies_on_user_id"

  create_table "secure_stats", :force => true do |t|
    t.integer  "company_id",                                                                                    :null => false
    t.integer  "gross_sales",                                       :limit => 8
    t.integer  "assets",                                            :limit => 8
    t.integer  "gross_profit",                                      :limit => 8
    t.integer  "operating_profit",                                  :limit => 8
    t.integer  "ebitda",                                            :limit => 8
    t.decimal  "ebitda_multiple",                                                :precision => 10, :scale => 2
    t.decimal  "sales_multiple",                                                 :precision => 10, :scale => 2
    t.decimal  "debt_multiple",                                                  :precision => 10, :scale => 2
    t.decimal  "stock_price",                                                    :precision => 10, :scale => 2
    t.integer  "reporting_scale",                                   :limit => 8
    t.integer  "input_basis",                                       :limit => 8
    t.integer  "quality",                                           :limit => 8
    t.date     "fye"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "Cash_Equivalents_and_Short_Term_Investments",       :limit => 8
    t.integer  "Receivables_Net",                                   :limit => 8
    t.integer  "Accounts_Receivable_Trade_Net",                     :limit => 8
    t.integer  "Other_Receivables",                                 :limit => 8
    t.integer  "Inventories_Net",                                   :limit => 8
    t.integer  "Inventories_Raw_Materials",                         :limit => 8
    t.integer  "Inventories_Work_in_Process",                       :limit => 8
    t.integer  "Inventories_Finished_Goods",                        :limit => 8
    t.integer  "Inventories_Supplies",                              :limit => 8
    t.integer  "Other_inventories",                                 :limit => 8
    t.integer  "Prepaid_Expenses",                                  :limit => 8
    t.integer  "Property_Plant_and_Equipment_Net",                  :limit => 8
    t.integer  "Property_Plant_and_Equipment_Gross",                :limit => 8
    t.integer  "Land_Buildings_and_Improvements",                   :limit => 8
    t.integer  "Machinery_and_Equipment",                           :limit => 8
    t.integer  "Other_Components",                                  :limit => 8
    t.integer  "Accumulated_Depreciation",                          :limit => 8
    t.integer  "Intangible_Assets_Net",                             :limit => 8
    t.integer  "Other_assets",                                      :limit => 8
    t.integer  "Liabilities",                                       :limit => 8
    t.integer  "Accounts_Payable_and_Accrued_Expenses",             :limit => 8
    t.integer  "Accounts_Payable",                                  :limit => 8
    t.integer  "Accuals_Other",                                     :limit => 8
    t.integer  "Debt_and_Capital_Lease_Obligations_Current",        :limit => 8
    t.integer  "Funded_Debt",                                       :limit => 8
    t.integer  "Bank_Debt",                                         :limit => 8
    t.integer  "Secured_Debt_Current",                              :limit => 8
    t.integer  "Line_of_Credit_Current",                            :limit => 8
    t.integer  "Secured_Long_Term",                                 :limit => 8
    t.integer  "Line_of_Credit_Long_Term",                          :limit => 8
    t.integer  "Unsecured_Debt",                                    :limit => 8
    t.integer  "Unsecured_Debt_Current",                            :limit => 8
    t.integer  "Unsecured_Debt_Long_Term",                          :limit => 8
    t.integer  "Mezzanine_Debt",                                    :limit => 8
    t.integer  "Subordinated_Debt_Current",                         :limit => 8
    t.integer  "Subordinated_Debt_Long_Term",                       :limit => 8
    t.integer  "Convertible_Debt",                                  :limit => 8
    t.integer  "Notes_Loans",                                       :limit => 8
    t.integer  "Capital_Lease_Obligations",                         :limit => 8
    t.integer  "Commercial_Paper",                                  :limit => 8
    t.integer  "Other_debts_liabilities",                           :limit => 8
    t.integer  "Equities",                                          :limit => 8
    t.integer  "Sales_Revenue_Net",                                 :limit => 8
    t.integer  "Revenue_from_Affiliates",                           :limit => 8
    t.integer  "Finance_Revenue",                                   :limit => 8
    t.integer  "Other_Operating_Revenue",                           :limit => 8
    t.integer  "Other_revenues",                                    :limit => 8
    t.integer  "Cost_of_Goods_and_Services_Sold",                   :limit => 8
    t.integer  "Cost_of_Goods_Sold",                                :limit => 8
    t.integer  "Cost_of_Goods_Sold_Direct_Materials",               :limit => 8
    t.integer  "Cost_of_Goods_Sold_Direct_Labor",                   :limit => 8
    t.integer  "Cost_of_Goods_Sold_Overhead",                       :limit => 8
    t.integer  "Cost_of_Goods_Sold_Depreciation_and_Amortization",  :limit => 8
    t.integer  "Cost_of_Goods_Sold_Other",                          :limit => 8
    t.integer  "Cost_of_Services",                                  :limit => 8
    t.integer  "Cost_of_Services_Direct_Materials",                 :limit => 8
    t.integer  "Cost_of_Services_Direct_Labor",                     :limit => 8
    t.integer  "Cost_of_Services_Overhead",                         :limit => 8
    t.integer  "Cost_of_Services_Depreciation_and_Amortization",    :limit => 8
    t.integer  "Cost_of_Services_Other",                            :limit => 8
    t.integer  "Other_Cost_of_Sales",                               :limit => 8
    t.integer  "Expense",                                           :limit => 8
    t.integer  "Selling_General_and_Administrative_Expenses",       :limit => 8
    t.integer  "General_and_Administrative_Expenses",               :limit => 8
    t.integer  "Labor_and_Related_Expenses",                        :limit => 8
    t.integer  "Salaries_and_Wages",                                :limit => 8
    t.integer  "Officers_Compensation",                             :limit => 8
    t.integer  "Postretirement_Benefit_Expense",                    :limit => 8
    t.integer  "Pension_and_Other_Employee_Benefit_Expense",        :limit => 8
    t.integer  "Other_Labor_and_Related_Expenses",                  :limit => 8
    t.integer  "Other_Labor_unaccounted",                           :limit => 8
    t.integer  "Lease_and_Rental_Expense",                          :limit => 8
    t.integer  "Travel_and_Entertainment_Expense",                  :limit => 8
    t.integer  "General_and_Administrative_Expenses_Other",         :limit => 8
    t.integer  "Other_G_A_unaccoutted",                             :limit => 8
    t.integer  "Selling_and_Marketing_Expenses",                    :limit => 8
    t.integer  "Selling_Expenses",                                  :limit => 8
    t.integer  "Marketing_and_Advertising_Expenses",                :limit => 8
    t.integer  "Other_selling_and_marketing_expenses",              :limit => 8
    t.integer  "Research_and_Development_Expense",                  :limit => 8
    t.integer  "Depreciation_and_Amortization",                     :limit => 8
    t.integer  "Provision_for_Doubtful_Accounts",                   :limit => 8
    t.integer  "Other_operating_expenses",                          :limit => 8
    t.integer  "Depreciation_and_Amortization_Total",               :limit => 8
    t.integer  "Depreciation_Non_Production",                       :limit => 8
    t.integer  "Amortization_Intangibles_Non_Productive",           :limit => 8
    t.integer  "Amortization_Acquisition_Costs",                    :limit => 8
    t.integer  "Depreciation_and_Amortization_Other_Unspecified",   :limit => 8
    t.integer  "Weighted_Average_Shares_Outstanding_Fully_Diluted", :limit => 8
    t.integer  "Equity_Valuation",                                  :limit => 8
    t.integer  "Assets_Valuation",                                  :limit => 8
    t.integer  "Enterprise_Book_Value",                             :limit => 8
    t.integer  "Enterprise_Market_Valuation",                       :limit => 8
    t.text     "xbrlfile"
  end

  add_index "secure_stats", ["company_id"], :name => "index_secure_stats_on_company_id"

  create_table "stat_filters", :force => true do |t|
    t.string   "name",                       :default => "default"
    t.integer  "user_id"
    t.integer  "country"
    t.integer  "region"
    t.integer  "revenue_low"
    t.integer  "revenue_high"
    t.integer  "asset_low"
    t.integer  "asset_high"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
    t.string   "sic_parent"
    t.boolean  "accounts_audit",             :default => true
    t.boolean  "accounts_review",            :default => true
    t.boolean  "accounts_mgt",               :default => true
    t.boolean  "user_cpa",                   :default => true
    t.boolean  "user_investment_banker",     :default => true
    t.boolean  "user_business_broker",       :default => true
    t.boolean  "user_business_appraiser",    :default => true
    t.boolean  "user_commercial_lender",     :default => true
    t.boolean  "user_private_investor",      :default => true
    t.boolean  "user_public_investor",       :default => true
    t.boolean  "user_financial_pro",         :default => true
    t.boolean  "user_executive",             :default => true
    t.boolean  "user_attorney",              :default => true
    t.boolean  "user_consultant",            :default => true
    t.boolean  "user_not_classified",        :default => true
    t.boolean  "entities_combination",       :default => true
    t.boolean  "entities_not_combination",   :default => true
    t.boolean  "ownership_public",           :default => true
    t.boolean  "ownership_private_investor", :default => true
    t.boolean  "ownership_private_operator", :default => true
    t.boolean  "ownership_division",         :default => true
    t.boolean  "user_stattrader",            :default => true
    t.string   "sic_level1"
    t.string   "sic_level2"
    t.string   "sic_level3"
    t.string   "sic_level4"
  end

  add_index "stat_filters", ["company_id"], :name => "index_stat_filters_on_company_id"

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
    t.datetime "fye"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trade_stats", ["company_id"], :name => "index_trade_stats_on_company_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                     :null => false
    t.string   "password_digest",                           :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "activated",              :default => false
    t.string   "activation_code"
    t.datetime "last_activation_email"
    t.datetime "last_password_email"
    t.integer  "type"
    t.integer  "subtype"
    t.string   "auth_token"
    t.string   "reset_password_code"
    t.datetime "reset_password_expires"
  end

end
