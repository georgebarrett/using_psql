# {{posts}} Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

If the table is already created in the database, you can skip this step.

Otherwise, [follow this recipe to design and create the SQL schema for your table](./single_table_design_recipe_template.md).

*In this template, we'll use an example table `students`*

```
# EXAMPLE

Table: posts

Columns:
id | title | content | number_of_views | account_id
```

## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
-- EXAMPLE
-- (file: spec/seeds_posts.sql)

-- Write your SQL seed here. 

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE posts RESTART IDENTITY CASCADE; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO posts (title, content, number_of_views, account_id) VALUES ('Hola', 'blah blah', 3, 1);
INSERT INTO posts (title, content, number_of_views, account_id) VALUES ('Mundo', 'meh meh', 2, 2);
```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 social_network_test < seeds_posts.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# EXAMPLE
# Table name: posts

# Model class
# (in lib/post.rb)
class Post
end

# Repository class
# (in lib/post_repository.rb)
class PostRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: posts

# Model class
# (in lib/post.rb)

class Post
  attr_accessor :id, :title, :content, :number_of_views, :account_id
end

# The keyword attr_accessor is a special Ruby feature
# which allows us to set and get attributes on an object,
# here's an example:
#
# post = post.new
# post.title = 'Aphex Twin'
# post.content = 'is the best'
# post.number_of_views = 10000
# post.account_id = 3
```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table name: posts

# Repository class
# (in lib/post_repository.rb)

class PostRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, title, content, number_of_views, acount_id FROM posts;

    # Returns an array of Post objects.
  end

  # select a single post record given its id
  # id argument is an integer
  def find(id) 
    # executes the SQL
    # SELECT id, title, content, number_of_views, account_id FROM posts WHERE id =$1;
    # returns a single Post object
  end

  # inserting a new post
  # post is a new post object
  def create(post)
    # INSERT INTO posts (title, content, number_of_views, account_id) VALUES($1, $2, $3, $4);

    # returns nothing
  end

  # deletes a post
  # takes an id as an object argument
  def delete(id)
    # sql
    # DELETE FROM posts WHERE id = $1;

    # returns nothing
  end

  # updates a post
  # takes post as the object argument 
  def update(post)
    # sql
    # UPDATE posts SET title = $1, content = $2, number_of_views = $3, account_id = $4 WHERE id = $5;

    # returns nothing
  end

end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

# Get all posts

repo = PostRepository.new

posts = repo.all

posts.length = 2
posts.first.id = 1
post.first.title = 'Hola'
post.first.content = 'blah blah'
post.first.number_of_views = 3
post.first.account_id = 1

# get single post 

repo = PostRepository.new

posts = repo.find(1)

posts.title = 'Hola'
posts.content = 'blah blah'
posts.number_of_views = 3
posts.account_id = 1


# get a different single account ('Aphra')

repo = PostRepository.new

posts = repo.find(2)

posts.title = 'Mundo'
posts.content = 'meh meh'
posts.number_of_views = 2
posts.account_id = 2


# insert a new post
repo = PostRepository.new

 repo = PostRepository.new

  new_post = Post.new
  new_post.title = 'Autechre'
  new_post.content = 'Inculabula'
  new_post.number_of_views = 6
  new_post.account_id = 1

  repo.create(new_post)

  all_posts = repo.all

  expect(all_posts).to include(
    have_attributes(
      title: 'Autechre', 
      content: 'Inculabula',
      number_of_views: 6,
      account_id: 1
    )
  )  
 
# delete account

repo = PostRepository.new

id_to_delete = 1

repo.delete(id_to_delete)

all_posts = repo.all
all_posts.length # => 1 (the seeds start the database with two)
all_posts.first.id # => 2

# deletes both accounts
repo = PostRepository.new

repo.delete(1)
repo.delete(2)

all_posts = repo.all
expect(all_posts.length).to eq (0)

# update entire account

repo = PostRepository.new

post = repo.find(1)
post.title = 'something'
post.content = 'something something what'
post.number_of_views = 6
post.account_id = 5

repo.update(post)

updated_post = repo.find(1)
updated_post.title = 'something'
updated_post.content = 'something something what'
updated_post.number_of_views = 6
updated_post.account_id = 5


# update single value of a post

repo = PostRepository.new

post = repo.find(1)
post.title = 'something'

repo.update(post)

updated_post = repo.find(1)

expect(updated_post.title).to eq 'something'
expect(updated_post.content).to eq 'blah blah'
expect(updated_post.number_of_views).to eq 3
expect(updated_post.account_id).to eq 1


```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/post_repository_spec.rb

def reset_posts_table
  seed_sql = File.read('spec/seeds_posts.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
  connection.exec(seed_sql)
end

describe PostRepository do
  before(:each) do 
    reset_posts_table
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._