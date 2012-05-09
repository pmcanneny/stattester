class UserCompanies < ActiveRecord::Migration
  def up
  	#user_companies table
    create_table :user_companies do |t|
      t.integer :pc_id, :null => false
      t.integer :user_id, :null => false
    end

    

  end

  def down
  end
end
