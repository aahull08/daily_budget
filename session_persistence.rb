class SessionPersistence
  
  def initialize(session)
    @session = session
    @session[:expenses] ||= {}
    @session[:daily_budget] ||= 0
  end
  
  def reset
    @session[:expenses] = {}
    @session[:daily_budget] = 0
  end
  
  def create_all_dates(start_date)
    expense_hsh = {}
    
    (start_date..Date.today).each do |date|
      expense_hsh[date] = []
    end
    
    @session[:expenses] = expense_hsh
  end
  
  def expenses
    @session[:expenses]
  end
  
  def set_daily_budget(daily_budget)
    @session[:daily_budget] = daily_budget
  end
  
  def get_daily_budget
    @session[:daily_budget]
  end
  
  def get_start_date
    @session[:expenses].keys[0]
  end
end