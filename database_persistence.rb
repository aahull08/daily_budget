require "pg"
require "date"

class DatabasePersistence
  
  def initialize(logger)
    @db = if Sinatra::Base.production?
            PG.connect(ENV['DATABASE_URL'])
          else
            PG.connect(dbname: "expenses")
          end
    @logger = logger
  end

  def query(statement, *params)
    @logger.info("#{statement} : #{params}")
    @db.exec_params(statement, params)
  end

  def reset
    sql = 'DELETE FROM date;'
    query(sql)
    sql = 'DELETE FROM expenses;'
    query(sql)
    sql = 'ALTER SEQUENCE date_id_seq RESTART WITH 1;'
    query(sql)
    sql = 'ALTER SEQUENCE expenses_id_seq RESTART WITH 1;'
    query(sql)
  end
  
  def create_all_dates(start_date, daily_budget)
    (start_date..Date.today).each do |date|
      string_date = date.strftime('%F')
      sql = <<~SQL
      INSERT INTO date(day, daily_budget)
      VALUES($1, $2);
      SQL
      query(sql, string_date, daily_budget)
    end

  end
  
  def expenses
    sql = 'SELECT day, cost FROM date 
          LEFT OUTER JOIN expenses ON 
          date.id = expenses.date_id
          ORDER BY expenses.id ASC;'
    result = query(sql)
    result_hsh = {}
    
    result.each do |tuple|
      date = Date.parse(tuple["day"])
      if result_hsh[date]
        result_hsh[date] << tuple["cost"].to_f
      else
        result_hsh[date] = [tuple["cost"].to_f]
      end
    end
    
    result_hsh
  end
  
  def insert_todays_date(daily_budget)
    string_date = Date.today.strftime('%F')
    insert_todays_date_sql = <<~SQL
    INSERT INTO date(day, daily_budget) VALUES ($1, $2)
    SQL
    query(insert_todays_date_sql, string_date, daily_budget)
  end

  def set_daily_budget(daily_budget)
    update_budget_sql = <<~SQL
    UPDATE date SET daily_budget = $1
    SQL
    query(update_budget_sql, daily_budget)
  end
  
  def get_daily_budget
    get_daily_budget_sql = <<~SQL
    SELECT daily_budget FROM date WHERE id = 1;
    SQL
    result = query(get_daily_budget_sql)
    if result.ntuples.zero?
      return 0
    else
      result[0]["daily_budget"]
    end
  end
  
  def get_total_daily_budget
    get_daily_budget_sql = <<~SQL
    SELECT SUM(daily_budget) FROM date;
    SQL
    result = query(get_daily_budget_sql)
    
    sum = ''
    
    result.each do |tuple|
      sum += tuple["sum"]
    end
    
    sum
  end
  
  def get_start_date
    start_date_sql = <<~SQL
    SELECT day FROM date ORDER BY day;
    SQL
    result = query(start_date_sql)
    Date.parse(result[0]["day"])
  end
  
  def add_expense(date, cost)
    date_id = get_date_id(date)
    add_expense_sql = <<~SQL
    INSERT INTO expenses(cost, date_id) VALUES ($1, $2)
    SQL
    query(add_expense_sql, cost, date_id)
  end
  
  def get_expense(date, index)
    date_id = get_date_id(date)
    expense_id = get_expense_id(date_id, index)
    get_expense_sql = <<~SQL
      SELECT cost from expenses WHERE id = $1
    SQL
    result = query(get_expense_sql, expense_id)
    result[0]["cost"].to_f
  end
  
  def destroy_expense(date, index)
    date_id = get_date_id(date)
    expense_id = get_expense_id(date_id, index)
    destroy_expense_sql = <<~SQL
    DELETE FROM expenses WHERE id = $1
    SQL
    query(destroy_expense_sql, expense_id)
  end
  
  
  def update_expense(cost, index, date)
    date_id = get_date_id(date)
    expense_id = get_expense_id(date_id, index)
    update_expense_sql = <<~SQL
    UPDATE expenses SET cost = $1 WHERE id = $2
    SQL
    query(update_expense_sql, cost, expense_id)
  end
  
  def disconnect
    @db.close
  end
  
  private

  def get_date_id(date)
    date_id_sql = <<~SQL
    SELECT id FROM date WHERE day = $1;
    SQL
    result = query(date_id_sql, date.to_s)
    result[0]["id"].to_i
  end
  
  def get_expense_id(date_id, index)
    index -= 1
    expense_id_sql = <<~SQL
      SELECT id FROM expenses WHERE date_id = $1
      ORDER BY id;
    SQL
    result = query(expense_id_sql, date_id);
    result[index]["id"]
  end

end