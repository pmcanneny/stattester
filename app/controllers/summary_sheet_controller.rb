#the controller for the summary sheet
class SummarySheetController < ApplicationController
	include ActionView::Helpers::NumberHelper
	layout "public_company"
  #each of the actions in this controller require a logged-in user
  before_filter :authenticate_user
  #The initial Summary Sheet page
  def index
	  @contentPageHeading = 'My Companies'
	  @companies = current_user.companies
	  @user_companies = UserCompany.where(:user_id => current_user.id)
	 #  @public_companies = Array.new
	 #  for user_company in @user_companies
	 #  	@public_companies.push(user_company,Company.find(user_company.pc_id))
	 #  end
		# @public_companies =  Company.find(:all, :order => 'name', :conditions => 'id  IN (SELECT pc_id FROM user_companies WHERE user_id =  '+current_user.id.to_s+')')
  end

  def listPublicCompanies
	 	@contentPageHeading = 'Search Public Company'
		@companies = Company.find(:all, :order => 'name', :conditions => 'c.user_id = -1 AND c.id NOT IN (SELECT pc_id FROM user_companies WHERE user_id =  '+current_user.id.to_s+')',  :joins => "as c left join secure_stats as s on s.id = c.secure_cy_id", :select => "c.id, c.name, c.ticker_symbol, c.sic, s.gross_profit, s.ebitda_multiple", :limit => 25)
  end

	def searchPublicCompanies
		cond = Array.new
		cond = cond + ["name LIKE '#{params[:name]}%'"]
		cond = cond + ["ticker_symbol LIKE '#{params[:symbol]}%'"]
		cond = cond + ["sic LIKE '#{params[:sic]}%'"]
		cond = cond + ["c.user_id = -1"]
		cond = cond + ["c.id NOT IN (SELECT pc_id FROM user_companies WHERE user_id =  "+current_user.id.to_s+")"]
		cond = cond.join(" AND ");
		@companies = Company.all(:conditions => cond, :order => 'name', :joins => "as c left join secure_stats as s on s.id = c.secure_cy_id", :select => "c.id, c.name, c.ticker_symbol, c.sic, s.gross_profit, s.ebitda_multiple")
		companyList = '';
		companyList = '<table class="table_prop" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			  <th style="text-align:left">Company</th>
			  <th>Trading Symbol</th>
			  <th>SIC</th>
			  <th>CY Revenue</th>
			   <th>Ebitda Multiple</th>
			   <th>Action</th>
		</tr>'
		@companies.each  do |company|
			if company.gross_profit.to_s.present?
				@cyRev = number_to_currency(company.gross_profit.to_s, :precision => 0, :separator => ",");
			else
				@cyRev  = ''
			end
			if company.ebitda_multiple.present?
				@ebitaMultiple = sprintf("%.1f",  company.ebitda_multiple.to_f)
			else
				@ebitaMultiple   = ''
			end
			
			companyList += '<tr><td width="400px" style="text-align:left">';
			companyList +=  "<a href= '/summary_sheet/listPublicCompanies' style = 'color:#000; font-weight:normal' >"+company.name+"</a>";
			companyList +=  '</td><td>'+ company.ticker_symbol + '</td><td>'+ company.sic + '</td>';
			companyList +=  "<td>"+ @cyRev + "</td><td>"+@ebitaMultiple+ "</td>";
			companyList +=  "<td><a href= '/summary_sheet/addPublicCompany/"+company.id.to_s+"' style = 'color:#000; font-weight:bold;' >Add</a><td>";
			companyList +=  '</tr>';
		end
		companyList += '</table>';
		render :text => companyList, :layout => false
	end

	def addPublicCompany
		# Check Id is valid
		@isInvalidCompanyId = Company.count(:all, :conditions => ["id = ?", params[:id]])
		if @isInvalidCompanyId == 0
			redirect_to summary_sheet_url, :notice => "Invalid company id"
			return;
		end

		# Check public company is not allready exist in our company list
		@checkPublicComExist = UserCompany.count(:all, :conditions => ["pc_id = ? AND user_id  = ?", params[:id], current_user.id])
		if @checkPublicComExist > 0
			redirect_to summary_sheet_url, :notice => "Allready added"
			return;
		end

		@usercompany  = UserCompany.new(:pc_id => params[:id], :user_id => current_user.id)
	 	if @usercompany.save
			redirect_to summary_sheet_url, :notice => "Company Saved!"
		else
			flash.now[:notice] = "Must enter company name. Please try again."
			redirect_to summary_sheet_url
	 	end			
	end

	#function for deleting a company
	def delete_company
		company = Company.find(params[:id])
		#verify that the logged-in user is authorized access
    authorize_user(company.user_id)

 		filters = StatFilter.where(:company_id => company.id)

 		for filter in filters 
 			filter.destroy
 		end

 		secure_now= SecureStat.find(company.secure_now)
		secure_now.destroy				
		secure_cy = SecureStat.find(company.secure_cy)
		secure_cy.destroy  			
  	secure_2y = SecureStat.find(company.secure_2y)
		secure_2y.destroy  			
  	secure_3y = SecureStat.find(company.secure_3y)
		secure_3y.destroy  			
  	secure_4y = SecureStat.find(company.secure_4y)
		secure_4y.destroy  			
  	secure_5y = SecureStat.find(company.secure_5y)
		secure_5y.destroy		

	 	trade_now= TradeStat.find(company.trade_now)
		trade_now.destroy  			
  	trade_cy = TradeStat.find(company.trade_cy)
		trade_cy.destroy  			
  	trade_2y = TradeStat.find(company.trade_2y)
		trade_2y.destroy  			
  	trade_3y = TradeStat.find(company.trade_3y)
		trade_3y.destroy  			
  	trade_4y = TradeStat.find(company.trade_4y)
		trade_4y.destroy  			
  	trade_5y = TradeStat.find(company.trade_5y)
		trade_5y.destroy 		

 		company.destroy

 		flash[:notice] = "Company deleted."
 		redirect_to summary_sheet_url
	end

	#deletes a company link 
	def delete_company_link
		company = UserCompany.find(params[:id])
		#verify that the logged-in user is authorized access
    authorize_user(company.user_id)

    #TODO: add logic here to delete filters

		company.destroy

		flash[:notice] = "Company removed."
 		redirect_to summary_sheet_url
	end

	  # #creating a new company
	  # def newcompany
	  # 	@company = Company.new
	  # end

	  # #action for creating a new company
	  # def createcompany
	  #   @company = Company.new(params[:company].merge(:user_id => current_user.id))
	  #   if @company.save
	  #     redirect_to summary_sheet_url, :notice => "Company Saved!"
	  #   else
	  #     flash.now[:notice] = "Must enter company name. Please try again."
	  #     render :action => 'newcompany'
	  #   end
	  # end

	  # #the edit company page
	  # def editcompany
	  #   @company = Company.find(params[:id])
	  #   #verify that the logged-in user is authorized to see this page
	  #   authorize_user(@company.user_id)
	  # end

	  # #action to update a company once it has been edited
	  # def updatecompany
	  #   @company = Company.find(params[:company][:id])
	  #   #verify that the logged-in user is authorized perform this action
	  #   authorize_user(@company.user_id)
	  #   if @company.update_attributes(params[:company])
	  #     redirect_to summary_sheet_url, :notice => "Company Updated!"
	  #   else
	  #     flash[:notice] = "Must enter company name. Please try again."
	  #     render :action => 'newcompany'
	  #   end
	  # end


end
