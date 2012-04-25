#methods available to the summary sheet views
module SummarySheetHelper

	def default_filter_public_count(company)
		#gather the companies that the filter applies to
		filter = StatFilter.find(company.current_filter_id)
  	Company.where(
      filter.region==0 ? "" : "region = #{filter.region}").where(
      #filter.country==0 ? "" : "country = #{filter.country}").where(
      filter.combination==0 ? "" : "combination = #{filter.combination}").where(
      	"ownership = 1").size.to_i
	end

	def default_filter_private_count(company)
		#gather the companies that the filter applies to
		filter = StatFilter.find(company.current_filter_id)
  	companies = Company.where(
      filter.region==0 ? "" : "region = #{filter.region}").where(
      #filter.country==0 ? "" : "country = #{filter.country}").where(
      filter.combination==0 ? "" : "combination = #{filter.combination}").where("ownership = 2")
    count = companies.size.to_i
    companies = Company.where(
      filter.region==0 ? "" : "region = #{filter.region}").where(
      #filter.country==0 ? "" : "country = #{filter.country}").where(
      filter.combination==0 ? "" : "combination = #{filter.combination}").where("ownership = 3")
    count += companies.size.to_i
    count
	end


end
