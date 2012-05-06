#methods available to the summary sheet views
module SummarySheetHelper

	def default_filter_public_count(company)
		#gather the companies that the filter applies to
		filter = StatFilter.find(company.current_filter)
  	quality_filter = Array.new
    quality_filter.push(1) if filter.accounts_audit
    quality_filter.push(2) if filter.accounts_review
    quality_filter.push(3) if filter.accounts_mgt

    tradestats = TradeStat.where(
      filter.revenue_low.to_f==0 ? "" : "revenue_category >= #{filter.revenue_low}").where(
      filter.revenue_high.to_f==0 ? "" : "revenue_category <= #{filter.revenue_high}").where(
      filter.asset_low.to_f==0 ? "" : "asset_category >= #{filter.asset_low}").where(
      filter.asset_high.to_f==0 ? "" : "asset_category <= #{filter.asset_high}").where(
      :quality => quality_filter)

    temp = tradestats.all(:select => 'DISTINCT company_id')
    company_ids1 = temp.map{|temp| temp.company_id}

    user_types = Array.new
    user_types.push(1) if filter.user_cpa
    user_types.push(2) if filter.user_investment_banker
    user_types.push(3) if filter.user_business_broker
    user_types.push(4) if filter.user_business_appraiser
    user_types.push(5) if filter.user_commercial_lender
    user_types.push(6) if filter.user_private_investor
    user_types.push(7) if filter.user_public_investor
    user_types.push(8) if filter.user_financial_pro
    user_types.push(9) if filter.user_executive
    user_types.push(10) if filter.user_attorney
    user_types.push(11) if filter.user_consultant
    user_types.push(12) if filter.user_not_classified
    users = User.where(:subtype => user_types)    

    temp = users.all(:select => :id)
    user_ids1 = temp.map{|temp| temp.id}
    user_ids1.push(-1) if filter.user_stattrader 

    #todo: Also filter out non-network valid companies    

    unless filter.sic_parent.nil? or filter.sic_parent.empty?
      sics = SIC.get_sics(filter.sic_parent)
      companies = Company.where(:sic => sics).where(:id => company_ids1).where(:user_id => user_ids1)
    else
      companies = Company.where(:id => company_ids1).where(:user_id => user_ids1)
    end

    combination_filter = Array.new
    combination_filter.push(1) if filter.entities_combination
    combination_filter.push(2) if filter.entities_not_combination

    ownership_filter = Array.new
    ownership_filter.push(1)

    #gather the companies that the filter applies to
    companies = companies.where(
      filter.region.to_f==0 ? "" : "region = #{filter.region}").where(
      :combination => combination_filter).where(
      :ownership => ownership_filter).size.to_i
	end

	def default_filter_private_count(company)
		#gather the companies that the filter applies to
		filter = StatFilter.find(company.current_filter)
    quality_filter = Array.new
    quality_filter.push(1) if filter.accounts_audit
    quality_filter.push(2) if filter.accounts_review
    quality_filter.push(3) if filter.accounts_mgt

    tradestats = TradeStat.where(
      filter.revenue_low.to_f==0 ? "" : "revenue_category >= #{filter.revenue_low}").where(
      filter.revenue_high.to_f==0 ? "" : "revenue_category <= #{filter.revenue_high}").where(
      filter.asset_low.to_f==0 ? "" : "asset_category >= #{filter.asset_low}").where(
      filter.asset_high.to_f==0 ? "" : "asset_category <= #{filter.asset_high}").where(
      :quality => quality_filter)

    temp = tradestats.all(:select => 'DISTINCT company_id')
    company_ids1 = temp.map{|temp| temp.company_id}

    user_types = Array.new
    user_types.push(1) if filter.user_cpa
    user_types.push(2) if filter.user_investment_banker
    user_types.push(3) if filter.user_business_broker
    user_types.push(4) if filter.user_business_appraiser
    user_types.push(5) if filter.user_commercial_lender
    user_types.push(6) if filter.user_private_investor
    user_types.push(7) if filter.user_public_investor
    user_types.push(8) if filter.user_financial_pro
    user_types.push(9) if filter.user_executive
    user_types.push(10) if filter.user_attorney
    user_types.push(11) if filter.user_consultant
    user_types.push(12) if filter.user_not_classified
    users = User.where(:subtype => user_types)    

    temp = users.all(:select => :id)
    user_ids1 = temp.map{|temp| temp.id}
    user_ids1.push(-1) if filter.user_stattrader 

    #todo: Also filter out non-network valid companies    

    unless filter.sic_parent.nil? or filter.sic_parent.empty?
      sics = SIC.get_sics(filter.sic_parent)
      companies = Company.where(:sic => sics).where(:id => company_ids1).where(:user_id => user_ids1)
    else
      companies = Company.where(:id => company_ids1).where(:user_id => user_ids1)
    end

    combination_filter = Array.new
    combination_filter.push(1) if filter.entities_combination
    combination_filter.push(2) if filter.entities_not_combination

    ownership_filter = Array.new
    ownership_filter.push(2)
    ownership_filter.push(3)
    ownership_filter.push(4)

    #gather the companies that the filter applies to
    companies = companies.where(
      filter.region.to_f==0 ? "" : "region = #{filter.region}").where(
      :combination => combination_filter).where(
      :ownership => ownership_filter).size.to_i
	end


end
