# Simple Daily Budget
[Simple Daily Budget](https://aahull08-daily-budget.herokuapp.com/daily_budget)
![image](https://user-images.githubusercontent.com/12583065/158086476-a533be90-f41b-4b64-8ec8-ba816552a05f.png)

## Discription
This is a simple budgeting app that allows a user to set a daily budget and keep track of expenses per day. The application keeps a running total based on the number of days you have been using the application and the total expenses during this time. 
This project is based on an sinatra/ruby backend connected to a posgres SQL database using a adapter pattern. The sql database has two tables on for the expenses and one for the dates and daily budget. In the future I wish to adapt this to three tables to seperate the date and daily budget to allow for more flexability. These tables are many to one relationship because there can be more than one expense for each day but only one date for each expense. 
The front-end uses vanilla HTML and CSS.

## Usage
Step 1: Create you daily Budget
![image](https://user-images.githubusercontent.com/12583065/158086616-4e764bdc-f75d-4bab-87a8-58c262a3f89a.png)
Step 2: Submit and go to homepage
![image](https://user-images.githubusercontent.com/12583065/158086643-9051192a-12f1-4fff-befa-4bd7fff0fbcd.png)
Step 3: Add expenses for the day
![image](https://user-images.githubusercontent.com/12583065/158086681-e75c8f84-0e50-4e21-ac15-431ae1d51e90.png)
Step 4: Edit an expense
![image](https://user-images.githubusercontent.com/12583065/158086735-2ea2e946-2788-40fe-8758-c74e198d6116.png)
![image](https://user-images.githubusercontent.com/12583065/158086765-6ad23502-739b-45ba-a6a5-f0ff8a1ebe1d.png)
Step 5: Delete an expense
![image](https://user-images.githubusercontent.com/12583065/158086810-ffe1bdd1-2c08-4ccb-8cb6-b9e6a87192e4.png)
![image](https://user-images.githubusercontent.com/12583065/158086830-53ccafd3-2ea6-4f37-b8ee-c4b2646f5c77.png)
Step 6: Adjust Daily Budget
![image](https://user-images.githubusercontent.com/12583065/158086869-3ced15ec-03a2-474c-a532-55ac54c6873b.png)
![image](https://user-images.githubusercontent.com/12583065/158086906-22ad8a5f-e4dd-47ec-8954-7f009292213c.png)

## Roadmap
In the future I wish to impliment a way to change the date for each expense on the edit page. Also I want to extract the daily budget from the day table in the sql database and create its own table. This will allow flexablity for the future. I will be able to allow users the oppertunity to change the daily budget going forward instead of changing all of the days daily budgets in one change.
