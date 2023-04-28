TRUNCATE TABLE accounts RESTART IDENTITY CASCADE; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO accounts (user_name, email) VALUES ('George', 'george@gmail.com');
INSERT INTO accounts (user_name, email) VALUES ('Aphra', 'aphra@gmail.com');