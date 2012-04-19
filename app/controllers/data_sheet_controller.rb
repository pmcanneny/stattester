#the controller for the data sheet
class DataSheetController < ApplicationController
	#each of the actions in this controller require a logged-in user
	before_filter :authenticate_user

	#the default data sheet action
	#we will simply redirect to the summary sheet, as the user should never get here
	def index
		redirect_to summary_sheet_url, :notice => "Page not found."
	end

	#this is the view/edit action of the data sheet
	def view
		@company = Company.find(params[:id])
		#verify that the logged-in user is authorized to see this page
		authorize_user(@company.user_id)
		#gather the company's secure data
		@secure_now = SecureStat.find(@company.secure_now_id)
		@secure_cy = SecureStat.find(@company.secure_cy_id)
		@secure_2y = SecureStat.find(@company.secure_2y_id)
		@secure_3y = SecureStat.find(@company.secure_3y_id)
		@secure_4y = SecureStat.find(@company.secure_4y_id)
		@secure_5y = SecureStat.find(@company.secure_5y_id)
    	#gather the company's trade data
    	@trade_now = TradeStat.find(@company.trade_now_id)
    	@trade_cy = TradeStat.find(@company.trade_cy_id)
    	@trade_2y = TradeStat.find(@company.trade_2y_id)
    	@trade_3y = TradeStat.find(@company.trade_3y_id)
    	@trade_4y = TradeStat.find(@company.trade_4y_id)
    	@trade_5y = TradeStat.find(@company.trade_5y_id)

        respond_to do |format|
            format.html
            format.xml { render :xml => @company }
            format.xls { send_data @company.datasheet_xls.string, content_type: 'application/vnd.ms-excel', :filename => "#{@company.name}.xls" }
        end
	end

	#'update' will update+save the data and refresh the page
	def update
        #fix params as they come in through the formatting javascript
        params.each do |key, value| 
          # target groups using regular expressions
          if (key.to_s[/(secure_.*)/])
            # whatever logic you need for params that start with 'setname1'
            params[key].each do |subkey, subvalue|
                unless params[key][subkey] == ""
                    params[key][subkey] = drop_dollar_format(params[key][subkey]).to_f
                end
            end
          end
        end
        params[:company][:id] = drop_dollar_format(params[:company][:id])

		@company = Company.find(params[:company][:id])
		#verify that the logged-in user is authorized perform this action
		authorize_user(@company.user_id)

        #check to make sure company data is valid before going further
        unless @company.update_attributes(params[:company])
            flash[:notice] = "Must enter company profile data. Please try again."
            redirect_to :action => :view, :id => @company.id
            return
        end

		#gather the company's secure data
		@secure_now = SecureStat.find(@company.secure_now_id)
		@secure_cy = SecureStat.find(@company.secure_cy_id)
		@secure_2y = SecureStat.find(@company.secure_2y_id)
		@secure_3y = SecureStat.find(@company.secure_3y_id)
		@secure_4y = SecureStat.find(@company.secure_4y_id)
		@secure_5y = SecureStat.find(@company.secure_5y_id)
    	#gather the company's trade data
    	@trade_now = TradeStat.find(@company.trade_now_id)
    	@trade_cy = TradeStat.find(@company.trade_cy_id)
    	@trade_2y = TradeStat.find(@company.trade_2y_id)
    	@trade_3y = TradeStat.find(@company.trade_3y_id)
    	@trade_4y = TradeStat.find(@company.trade_4y_id)
    	@trade_5y = TradeStat.find(@company.trade_5y_id)
    	#set the cy fye param for use in update command below
    	unless params[:secure_cy][:fye].to_i == 0
    	  params[:secure_cy][:fye] = DateTime.now-params[:secure_cy][:fye].to_i.months
    	else
    	  params[:secure_cy][:fye] = @secure_cy.fye
    	end
    	#set the reporting scales for use (changing the cy reporting scale changes them all)
    	params[:secure_now][:reporting_scale] = params[:secure_cy][:reporting_scale]
    	params[:secure_2y][:reporting_scale] = params[:secure_cy][:reporting_scale]
    	params[:secure_3y][:reporting_scale] = params[:secure_cy][:reporting_scale]
    	params[:secure_4y][:reporting_scale] = params[:secure_cy][:reporting_scale]
    	params[:secure_5y][:reporting_scale] = params[:secure_cy][:reporting_scale]

    	#update the securestats transactionally
    	SecureStat.transaction do 
    	  @secure_now.update_attributes(params[:secure_now])
    	  @secure_cy.update_attributes(params[:secure_cy])
    	  @secure_2y.update_attributes(params[:secure_2y])
    	  @secure_3y.update_attributes(params[:secure_3y])
    	  @secure_4y.update_attributes(params[:secure_4y])
    	  @secure_5y.update_attributes(params[:secure_5y])
    	end
    	#if there are any errors, this should catch them
    	unless 	@secure_now.errors.empty? and
    			@secure_cy.errors.empty? and
    			@secure_2y.errors.empty? and
    			@secure_3y.errors.empty? and
    			@secure_4y.errors.empty? and 
    			@secure_5y.errors.empty? 
           flash[:notice] = "Errors. Data not updated."
    	   redirect_to :action => :view, :id =>@company.id 
    	   return
    	end
    	#calculate trade stats from secure stats
		@trade_now.calculate_stats!(@secure_now)
		@trade_cy.calculate_stats!(@secure_cy)
		@trade_2y.calculate_stats!(@secure_2y)
		@trade_3y.calculate_stats!(@secure_3y)
		@trade_4y.calculate_stats!(@secure_4y)
		@trade_5y.calculate_stats!(@secure_5y)

        flash[:notice] = "Company Updated."		
	    redirect_to :action => :view, :id =>@company.id	    
	end

    #new company page
    def new
        @company = Company.new(:user_id => current_user.id)
        #verify that the logged-in user is authorized to see this page
        authorize_user(@company.user_id)
        #gather the company's secure data
        @secure_now = SecureStat.new
        @secure_cy = SecureStat.new
        @secure_2y = SecureStat.new
        @secure_3y = SecureStat.new
        @secure_4y = SecureStat.new
        @secure_5y = SecureStat.new
        #gather the company's trade data
        @trade_now = TradeStat.new
        @trade_cy = TradeStat.new
        @trade_2y = TradeStat.new
        @trade_3y = TradeStat.new
        @trade_4y = TradeStat.new
        @trade_5y = TradeStat.new
    end

    #action for creating a new company
    def createcompany
        @company = Company.new(params[:company])
        @company.user_id = current_user.id
        unless @company.save
            flash[:notice] = "Must enter company profile data. Please try again."
            redirect_to :action => :new
            return
        end
        
        #gather the company's secure data
        @secure_now = SecureStat.find(@company.secure_now_id)
        @secure_cy = SecureStat.find(@company.secure_cy_id)
        @secure_2y = SecureStat.find(@company.secure_2y_id)
        @secure_3y = SecureStat.find(@company.secure_3y_id)
        @secure_4y = SecureStat.find(@company.secure_4y_id)
        @secure_5y = SecureStat.find(@company.secure_5y_id)
        #gather the company's trade data
        @trade_now = TradeStat.find(@company.trade_now_id)
        @trade_cy = TradeStat.find(@company.trade_cy_id)
        @trade_2y = TradeStat.find(@company.trade_2y_id)
        @trade_3y = TradeStat.find(@company.trade_3y_id)
        @trade_4y = TradeStat.find(@company.trade_4y_id)
        @trade_5y = TradeStat.find(@company.trade_5y_id)
        #set the cy fye param for use in update command below
        unless params[:secure_cy][:fye].to_i == 0
          params[:secure_cy][:fye] = DateTime.now-params[:secure_cy][:fye].to_i.months
        else
          params[:secure_cy][:fye] = @secure_cy.fye
        end
        #set the reporting scales for use (changing the cy reporting scale changes them all)
        params[:secure_now][:reporting_scale] = params[:secure_cy][:reporting_scale]
        params[:secure_2y][:reporting_scale] = params[:secure_cy][:reporting_scale]
        params[:secure_3y][:reporting_scale] = params[:secure_cy][:reporting_scale]
        params[:secure_4y][:reporting_scale] = params[:secure_cy][:reporting_scale]
        params[:secure_5y][:reporting_scale] = params[:secure_cy][:reporting_scale]

        #update the securestats transactionally
        SecureStat.transaction do 
          @secure_now.update_attributes(params[:secure_now])
          @secure_cy.update_attributes(params[:secure_cy])
          @secure_2y.update_attributes(params[:secure_2y])
          @secure_3y.update_attributes(params[:secure_3y])
          @secure_4y.update_attributes(params[:secure_4y])
          @secure_5y.update_attributes(params[:secure_5y])
        end
        #if there are any errors, this should catch them
        unless  @secure_now.errors.empty? and
                @secure_cy.errors.empty? and
                @secure_2y.errors.empty? and
                @secure_3y.errors.empty? and
                @secure_4y.errors.empty? and 
                @secure_5y.errors.empty? 
            flash[:notice] = "Due to errors, company saved but data not updated."
            redirect_to :action => :view, :id =>@company.id
            return
        end
        #calculate trade stats from secure stats
        @trade_now.calculate_stats!(@secure_now)
        @trade_cy.calculate_stats!(@secure_cy)
        @trade_2y.calculate_stats!(@secure_2y)
        @trade_3y.calculate_stats!(@secure_3y)
        @trade_4y.calculate_stats!(@secure_4y)
        @trade_5y.calculate_stats!(@secure_5y)
        
        flash[:notice] = "Company Saved."
        redirect_to :action => :view, :id =>@company.id
    end

	#'done' will update+save the data and redirect to the summary sheet
	def done
		redirect_to summary_sheet_url
	end



    private 

    #drop the dollar signs and commas from submitted string
    def drop_dollar_format(string)        
        string.gsub(/(,)|(\$)/,"")        
    end

end
