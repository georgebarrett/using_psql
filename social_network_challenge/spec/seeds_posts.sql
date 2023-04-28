TRUNCATE TABLE posts RESTART IDENTITY CASCADE; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO posts (title, content, number_of_views, account_id) VALUES ('Hola', 'blah blah', 3, 1);
INSERT INTO posts (title, content, number_of_views, account_id) VALUES ('Mundo', 'meh meh', 2, 2);
