class Apr22 < ActiveRecord::Migration
  def up
  	rename_column :companies, :default_filter_id, :current_filter_id
  	change_column :stat_filters, :name, :string
  end

  def down
  end
end
