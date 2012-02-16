#the controller for the summary sheet
class SummarySheetController < ApplicationController
  #each of the actions in this controller require a logged-in user
  before_filter :authenticate_user

  #The initial Summary Sheet page
  def index
  	@companies = current_user.companies
  end

  #creating a new company
  def newcompany
  	@company = Company.new
  end

  #action for creating a new company
  def createcompany
    @company = Company.new(params[:company].merge(:user_id => current_user.id))
    if @company.save
      redirect_to summary_sheet_url, :notice => "Company Saved!"
    else
      flash.now[:notice] = "Must enter company name. Please try again."
      render :action => 'newcompany'
    end
  end

  #the edit company page
  def editcompany
    @company = Company.find(params[:id])
    #verify that the logged-in user is authorized to see this page
    authorize_user(@company.user_id)
  end

  #action to update a company once it has been edited
  def updatecompany
    @company = Company.find(params[:company][:id])
    #verify that the logged-in user is authorized perform this action
    authorize_user(@company.user_id)
    if @company.update_attributes(params[:company])
      redirect_to summary_sheet_url, :notice => "Company Updated!"
    else
      flash[:notice] = "Must enter company name. Please try again."
      render :action => 'newcompany'
    end
  end


end
