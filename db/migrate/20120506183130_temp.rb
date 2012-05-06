class Temp < ActiveRecord::Migration
  def up
  	add_column :stat_filters, :sic_level1, :string
  	add_column :stat_filters, :sic_level2, :string
  	add_column :stat_filters, :sic_level3, :string
  	add_column :stat_filters, :sic_level4, :string
  end

  def down
  end
end
