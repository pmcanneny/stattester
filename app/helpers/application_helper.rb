#This is a module containing various helper methods for the application
module ApplicationHelper

  #helper method for printing out the 'flash notice'
  #will not include the div tags if the notice is empty
  def show_notice(notice)
    notice.nil? || notice.empty? ? "" : simple_format("<div id=\"flashMessage\" class=\"notice\">#{notice}</div>")
  end

  #add commas to the thousands places for numbers
  def thousands(number)
    number.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")
  end

  #return the month + year X months before the current date
  def fye(f)
    unless f.nil?
      fye_format(DateTime.now-f.months)
    else
      ""
    end
  end

  #return fye options for use in drop-down
  def fye_options(current)
    {
    fye_format(current)=>0,
    fye(1)=>1,fye(2)=>2,fye(3)=>3,fye(4)=>4,fye(5)=>5,fye(6)=>6,fye(7)=>7,fye(8)=>8,fye(9)=>9,
    fye(10)=>10,fye(11)=>11,fye(12)=>12,fye(13)=>13,fye(14)=>14,fye(15)=>15,fye(16)=>16,fye(17)=>17,fye(18)=>18
    }
  end

  #format the date (the format used for fye dates)
  def fye_format(date)
    unless date.nil?
      "#{month_word(date.month)} #{date.year}"
    else
      ""
    end
  end

   #takes a month number, returns the month word
  def month_word(m)
    case m
    when 1
      "Jan"
    when 2
      "Feb"
    when 3
      "Mar"
    when 4 
      "Apr"
    when 5 
      "May"
    when 6 
      "Jun"
    when 7 
      "Jul"
    when 8 
      "Aug"
    when 9 
      "Sep"
    when 10 
      "Oct"
    when 11
      "Nov"
    when 12
      "Dec"
    else
      ""
    end
  end 

  
end