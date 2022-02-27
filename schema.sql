CREATE TABLE date (
  id serial PRIMARY KEY,
  day Date NOT NULL UNIQUE,
  daily_budget numeric NOT NULL
);
  
CREATE TABLE expenses (
  id serial PRIMARY KEY,
  cost numeric NOT NULL,
  date_id integer NOT NULL REFERENCES date(id) ON DELETE CASCADE
);