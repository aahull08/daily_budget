require "sinatra"
require "sinatra/content_for"
require "tilt/erubis"
require 'date'

require_relative "database_persistence"

configure do
  enable :sessions
  set :session_secret, "secret"
  set :erb, :escape_html => true
end

configure(:development) do
  require "sinatra/reloader"
  also_reload "database_persistence.rb"
end

helpers do
  def as_money(num)
    sprintf("%.2f", num.to_f)
  end
end



before do
  @storage = DatabasePersistence.new(logger)
end

def make_date(date_as_string)
  date_array = date_as_string.split('-')
  
  year = date_array[0].to_i
  month = date_array[1].to_i
  day = date_array[2].to_i
  
  
  Date.new(year, month, day)
end

#returns the total of all the expenses
def total_expenses(expenses_hsh)
  expenses_hsh.values.flatten.sum
end

#redirects to the main page
get '/' do
  redirect '/daily_budget'
end

#clears the data tables
get '/set_up' do
  @storage.reset
  erb :log_in, layout: :layout
end

#Adds data to the date data table that includes all the dates and the 
#daily budget for each of them.
post'/' do
  daily_budget = params[:daily_budget].to_f
  if daily_budget > 0
    @storage.set_daily_budget(daily_budget)
  else
    session[:error] = "Please enter a daily budget greater than zero"
    redirect '/set_up'
  end
  
  start_date = make_date(params[:start_date])
  if start_date <= Date.today
    @storage.create_all_dates(start_date, daily_budget)
  else
    session[:error] = "Please enter a date of today or earlier"
    redirect '/set_up'
  end
  
  session[:success] = "Your daily budget has been created!"

  redirect "/daily_budget"
end

#retireves the date, daily budget, 
get '/daily_budget' do
  
  daily_budget = @storage.get_daily_budget
  @expenses = @storage.expenses
  unless @expenses.keys.include?(Date.today)
    @storage.insert_todays_date(daily_budget)
  end
    

  @total = @storage.get_total_daily_budget.to_i - total_expenses(@expenses)
  erb :test, layout: :layout
  erb :daily_budget, layout: :layout
end

get "/new_expense" do
  @todays_date = Date.today
  erb :new_expense, layout: :layout
end

post '/new_expense' do
  date_of_expense = make_date(params[:date_of_expense])
  cost = params[:new_expense].to_f

  if date_of_expense <= Date.today && date_of_expense >= @storage.get_start_date && cost > 0
    session[:success] = "Your expense has been added!"
  elsif cost <= 0
    session[:error] = "Please enter an expense greater than zero."
    redirect '/new_expense'
  else
    session[:error] = "Please enter a date between the start and end date."
    redirect '/new_expense'
  end

  @storage.add_expense(date_of_expense, cost)
  redirect '/daily_budget'
end

get '/edit_expense/:day/:expense' do
  @day = make_date(params[:day])
  @index = params[:expense].to_i
  @expense = @storage.get_expense(@day, @index)
  
  erb :edit_expense, layout: :layout
end

post '/edit_expense/destroy/:day/:expense' do
  date = make_date(params[:day])
  index = params[:expense].to_i

  @storage.destroy_expense(date, index)

  redirect '/daily_budget'
end

post '/edit_expense/:day/:expense' do
  date_of_expense = params[:day]
  date = make_date(date_of_expense)
  cost = params[:edited_expense].to_f
  index = params[:expense].to_i
  
  if cost > 0
    session[:success] = "Your expense has been updated"
  else
    session[:error] = "Please enter an expense greater than zero"
    redirect "/edit_expense/#{date}/#{index}"
  end


  
  @storage.update_expense(cost, index, date)
  redirect '/daily_budget'
end

get "/settings" do
  @daily_budget = @storage.get_daily_budget
  erb :settings, layout: :layout
end

post "/settings" do
  new_daily_budget = params[:daily_budget].to_f
  
  if new_daily_budget > 0
    session[:success] = "Your daily budget has been updated"
  else
    session[:error] = "Please enter a daily budget greater than zero"
    redirect '/settings'
  end
  
  @storage.set_daily_budget(new_daily_budget.to_f)
  redirect '/daily_budget'
end

after do
  @storage.disconnect
end