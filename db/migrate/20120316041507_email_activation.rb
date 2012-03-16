#add appropriate columns for email activation
class EmailActivation < ActiveRecord::Migration
  def change
  	add_column :users, :activated, :boolean, :defailt => false #email activation/confirmation
  	add_column :users, :activation_code, :integer
  end

end
