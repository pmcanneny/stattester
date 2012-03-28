#add appropriate columns for email activation
class EmailActivation < ActiveRecord::Migration
  def up
  	add_column :users, :activated, :boolean, :default => false #email activation/confirmation
  	add_column :users, :activation_code, :integer
  end

end
