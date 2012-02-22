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

ActiveRecord::Schema.define(:version => 20120131174501) do

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
  end

  create_table "secure_stats", :force => true do |t|
    t.integer  "company_id",                                      :null => false
    t.integer  "gross_sales"
    t.integer  "assets"
    t.integer  "gross_profit"
    t.integer  "operating_profit"
    t.integer  "ebitda"
    t.decimal  "ebitda_multiple",  :precision => 10, :scale => 1
    t.decimal  "sales_multiple",   :precision => 10, :scale => 1
    t.decimal  "debt_multiple",    :precision => 10, :scale => 1
    t.decimal  "stock_price"
    t.integer  "reporting_scale"
    t.integer  "input_basis"
    t.integer  "quality"
    t.integer  "year"
    t.datetime "fye"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.string   "email",           :null => false
    t.string   "password_digest", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
