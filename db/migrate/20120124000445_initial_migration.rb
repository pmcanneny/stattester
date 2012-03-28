#the initial migration for the stattrader project
class InitialMigration < ActiveRecord::Migration
  
  #perform the initial migration
  def up

    #users table as defined in the user.rb model
    create_table :users do |t|
      t.string :email, :null => false
      t.string :password_digest, :null => false
      
      t.timestamps
    end

    #companies table as defined in the company.rb model
    create_table :companies do |t|
      t.string :name, :null => false
      t.references :user, :null => false
      t.integer :combination, :precision => 1, :default => 2 #1=yes 2=no
      t.integer :ownership, :precision => 1 #public, private investor, or private operator
      t.integer :sic, :precision => 4 #sic codes are up to 4 digits
      t.integer :country, :precision => 3, :default => 1 #about 200 countries in the world
      t.integer :region, :precision => 1 #there are arguably 9 regions in the US
      t.boolean :shifted, :default => false #has this company's data been year-shifted? - possible UI feature
      t.timestamps
      #now we get into the data to be later encrypted
      t.references "secure_now"
      t.references "secure_cy"
      t.references "secure_2y"
      t.references "secure_3y"
      t.references "secure_4y"
      t.references "secure_5y"
      #these are the stats that are traded anonymously
      t.references "trade_now"
      t.references "trade_cy"
      t.references "trade_2y"
      t.references "trade_3y"
      t.references "trade_4y"
      t.references "trade_5y"
      #reference the default stat filter
      t.references :default_filter
    end

    #
    #Precision is the total number of digits, scale is the number digits after the decimal point.
    #

    #stat_filter table as defined in stat_filter.rb
    create_table :stat_filters do |t|
      t.string :name
      t.references :user #company default filters will not have an associated user
      t.integer :combination, :precision => 1
      t.integer :ownership, :precision => 1 #public, private investor, or private operator
      t.integer :sic_low, :precision => 4 #sic codes are up to 4 digits
      t.integer :sic_high, :precision => 4 #sic codes are up to 4 digits
      t.integer :country, :precision => 3 #about 200 countries in the world
      t.integer :region, :precision => 1 #there are arguably 9 regions in the US
      t.integer :revenue_low, :precision => 2
      t.integer :revenue_high, :precision => 2
      t.integer :asset_low, :precision => 2
      t.integer :asset_high, :precision => 2
      t.integer :input_basis, :precision => 1 #"transaction based" or "my estimate"
      t.integer :quality, :precision => 1 #audit, review, or "mgt/compiled"
      t.timestamps
    end

    #secure_stats table as defined in the secure_stat.rb model
    create_table :secure_stats do |t|
      t.references :company, :null => false
      t.integer :gross_sales# "revenue"
      t.integer :assets
      t.integer :gross_profit
      t.integer :operating_profit ## not found
      t.integer :ebitda
      t.decimal :ebitda_multiple, :precision => 10, :scale => 1
      t.decimal :sales_multiple, :precision => 10, :scale => 1
      t.decimal :debt_multiple, :precision => 10, :scale => 1
      t.decimal :stock_price
      t.integer :reporting_scale #dollars, thousands of dollars, millions, or billions
      t.integer :input_basis, :precision => 1 #"transaction based" or "my estimate"
      t.integer :quality, :precision => 1 #audit, review, or "mgt/compiled"
      t.integer :year, :precision => 1 #now, cy, 2y, 3y, 4y, or 5y
      t.datetime :fye #month and year of fiscal year end
      t.timestamps
    end

    #trade_stats table as defined in the trade_stat.rb models
    create_table :trade_stats do |t|
      t.references :company, :null => false
      t.integer :revenue_category, :precision => 2
      t.integer :asset_category, :precision => 2
      t.decimal :sales_growth, :precision => 10, :scale => 1
      t.decimal :gross_profit_margin, :precision => 10, :scale => 1
      t.decimal :operating_profit_margin, :precision => 10, :scale => 1
      t.decimal :ebitda_percent, :precision => 10, :scale => 1
      t.decimal :enterprise_multiple, :precision => 10, :scale => 1
      t.decimal :ebitda_multiple, :precision => 10, :scale => 1
      t.decimal :sales_multiple, :precision => 10, :scale => 1
      t.decimal :debt_multiple, :precision => 10, :scale => 1
      t.integer :input_basis, :precision => 1 #"transaction based" or "my estimate"
      t.integer :quality, :precision => 1 #audit, review, or "mgt/compiled"
      t.integer :year, :precision => 1 #now, cy, 2y, 3y, 4y, or 5y
      t.datetime :fye #month and year of fiscal year end
      t.timestamps
    end    



    #static database data



    ##########testing section##########

    #create user for testing
    #User.create :email => "stat1@stattrader.com", :password => "1234"
    #User.create :email => "stat2@stattrader.com", :password => "1234"

    #create some companies for the test user
    #Alberto Culver - 1
    Company.create :name => "Alberto Culver", :user_id => 1
    #Avon - 2
    Company.create :name => "Avon", :user_id => 1
    #Bare Essentials - 3
    # Company.create :name => "Bare Essentials", :user_id => 2
    # #China green creative - 4
    # Company.create :name => "China Green creative", :user_id => 1
    # #Colgate Palmolive - 5
    # Company.create :name => "Colgate Palmolive", :user_id => 1
    # #Divine Skin - 6 
    # Company.create :name => "Divine Skin", :user_id => 1
    # #Elizabeth Arden - 7
    # Company.create :name => "Elizabeth Arden", :user_id => 1
    # #Estee Lauder - 8
    # Company.create :name => "Estee Lauder", :user_id => 1
    # #Human Phermone Sciences - 9
    # Company.create :name => "Human Phermone Sciences", :user_id => 1
    # #OmniReliant Holdings - 10
    # Company.create :name => "OmniReliant Holdings", :user_id => 1
    # #Inter Parfums - 11
    # Company.create :name => "Inter Parfums", :user_id => 1
    # #Parlux Fragrances - 12
    # Company.create :name => "Parlux Fragrances", :user_id => 1
    #
    

    #create data for companies
    #Alberto Culver
    alberto = Company.find(1)
    alberto.combination = 1
    alberto.ownership = 1
    alberto.sic = 2841
    alberto.country = 1
    alberto.region = 1
    alberto_now = SecureStat.find(Company.find(1).secure_now_id)
    alberto_cy = SecureStat.find(Company.find(1).secure_cy_id)
    alberto_2y = SecureStat.find(Company.find(1).secure_2y_id)
    alberto_3y = SecureStat.find(Company.find(1).secure_3y_id)
    alberto_cy.fye = "1/1/2010".to_datetime
    alberto_now.gross_sales = 1700000
    alberto_now.assets = 2000000
    alberto_now.gross_profit = 950000
    alberto_now.operating_profit = 275000
    alberto_now.ebitda = 30000
    alberto_now.ebitda_multiple = 14.0
    alberto_now.sales_multiple = 2.0
    alberto_now.debt_multiple = 2.0
    alberto_cy.gross_sales = 1597233
    alberto_cy.assets = 1878275
    alberto_cy.gross_profit = 834676
    alberto_cy.operating_profit = 220168
    alberto_cy.ebitda = 249269
    alberto_cy.ebitda_multiple = 13.6
    alberto_cy.sales_multiple = 2.5
    alberto_cy.debt_multiple = 2.5
    alberto_2y.gross_sales = 1433980
    alberto_2y.assets = 1558014
    alberto_2y.gross_profit = 735202
    alberto_2y.operating_profit = 183165
    alberto_2y.ebitda = 208131
    alberto_2y.ebitda_multiple = 12.5
    alberto_2y.sales_multiple = 2.0
    alberto_2y.debt_multiple = 2.0
    alberto_3y.gross_sales = 1443456
    #alberto_3y.assets = 
    alberto_3y.gross_profit = 757281
    alberto_3y.operating_profit = 161221
    alberto_3y.ebitda = 184830
    alberto_3y.ebitda_multiple = 13.5
    alberto_3y.sales_multiple = 1.7
    alberto_3y.debt_multiple = 1.7
    alberto.save
    alberto_now.save
    alberto_cy.save
    alberto_2y.save
    alberto_3y.save

    #avon
    avon = Company.find(2)
    avon.combination = 1
    avon.ownership = 1
    avon.sic = 2841
    avon.country = 1
    avon.region = 1
    avon_now = SecureStat.find(Company.find(2).secure_now_id)
    avon_cy = SecureStat.find(Company.find(2).secure_cy_id)
    avon_2y = SecureStat.find(Company.find(2).secure_2y_id)
    avon_3y = SecureStat.find(Company.find(2).secure_3y_id)
    avon_cy.fye = "1/1/2010".to_datetime
    avon_now.gross_sales = 11000000
    avon_now.assets = 8000000
    avon_now.gross_profit = 7000000
    avon_now.operating_profit = 1100000
    avon_now.ebitda = 1300000
    avon_now.ebitda_multiple = 10.5
    avon_now.sales_multiple = 2.0
    avon_now.debt_multiple = 2.0
    avon_cy.gross_sales = 10862800
    avon_cy.assets = 7873700
    avon_cy.gross_profit = 6821500
    avon_cy.operating_profit = 1073100
    avon_cy.ebitda = 1267900
    avon_cy.ebitda_multiple = 13.6
    avon_cy.sales_multiple = 2.5
    avon_cy.debt_multiple = 2.5
    avon_2y.gross_sales = 10205200
    avon_2y.assets = 6823400
    avon_2y.gross_profit = 6379700
    avon_2y.operating_profit = 1005600
    avon_2y.ebitda = 1180900
    avon_2y.ebitda_multiple = 12.5
    avon_2y.sales_multiple = 2.0
    avon_2y.debt_multiple = 2.0
    avon_3y.gross_sales = 10507500
    #avon_3y.assets = 
    avon_3y.gross_profit = 6623600
    avon_3y.operating_profit = 1324500
    avon_3y.ebitda = 1506100
    avon_3y.ebitda_multiple = 13.5
    avon_3y.sales_multiple = 1.7
    avon_3y.debt_multiple = 1.7
    avon.save
    avon_now.save
    avon_cy.save
    avon_2y.save
    avon_3y.save


  end

  #reverse the initial migration
  def down
  	
  	drop_table :users
    drop_table :companies
    drop_table :trade_stats
    drop_table :secure_stats
    drop_table :stat_filters


  end
end
