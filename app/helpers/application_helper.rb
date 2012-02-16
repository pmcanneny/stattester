#This is a module containing various helper methods for the application
module ApplicationHelper


	
  #helper method for printing out the 'flash notice'
  #will not include the div tags if the notice is empty
  def show_notice(notice)
    notice.nil? || notice.empty? ? "" : simple_format("<div id=\"flashMessage\" class=\"message\">#{notice}</div>")
  end


  #add commas to the thousands places for numbers
  def thousands(number)
    number.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")
  end



end
