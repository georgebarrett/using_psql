# {{recipes_directory}} Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

If the table is already created in the database, you can skip this step.

Otherwise, [follow this recipe to design and create the SQL schema for your table](./single_table_design_recipe_template.md).

*In this template, we'll use an example table `students`*

```
# EXAMPLE

As a food lover,
So I can stay organised and decide what to cook,
I'd like to keep a list of all my recipes with their names.

As a food lover,
So I can stay organised and decide what to cook,
I'd like to keep the average cooking time (in minutes) for each recipe.

As a food lover,
So I can stay organised and decide what to cook,
I'd like to give a rating to each of the recipes (from 1 to 5).

Table: recipies

Columns:
id | name | cooking_time | rating
```

## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
-- EXAMPLE
-- (file: spec/seeds_recipies_directory.sql)

-- Write your SQL seed here. 

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE recipies RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO recipies (name, cooking_time, rating) VALUES ('Bangers and Mash', '45', '1');
INSERT INTO recipies (name, cooking_time, rating) VALUES ('Fish and Chips', '30', '1');
```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 recipies_directory < seeds_recipies_directory.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# EXAMPLE
# Table name: recipe

# Model class
# (in lib/recipe.rb)
class Recipe
end

# Repository class
# (in lib/recipe_repository.rb)
class RecipeRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: recipies

# Model class
# (in lib/recipies.rb)

class Recipies
  attr_accessor :id, :name, :cooking_time, :rating
end

# The keyword attr_accessor is a special Ruby feature
# which allows us to set and get attributes on an object,
# here's an example:
#
# recipe = Recipe.new
# recipe.name = 'Bangers and Mash'
# recipe.cooking_time = '45'
# recipe.rating = '2'
```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table name: recipies

# Repository class
# (in lib/recipies_repository.rb)

class RecipeRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, name, cooking_time, rating FROM recipies;

    # Returns an array of Recipe objects.
  end

  # select a single album record given its id
  # id argument is an integer
  def find(id) 
    # executes the SQL
    # SELECT id, name, cooking_time, rating FROM recipies WHERE id =$1;
    # returns a single Recipe object
  end
end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

# 1
# Get all recipies

repo = RecipeRepository.new

recipies = repo.all

recipies.length = 2
recipies.first.id = "1"
recipies.first.name = "Bangers and Mash"
recipies.first.cooking_time = "45"
recipies.first.rating = "4"

# 2
# get single recipe ('Bangers and Mash')

repo = RecipeRepository.new

recipies = repo.find(1)

recipies.first.name = "Bangers and Mash"
recipies.first.cooking_time = "45"
recipies.first.rating = "4"



# 3
# get single album ('Fish and Chips')

repo = AlbumRepository.new

albums = repo.find(2)

recipies.first.name = "Fish and Chips"
recipies.first.cooking_time = "30"
recipies.first.rating = "5"

```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/recipe_repository_spec.rb

def reset_recipies_table
  seed_sql = File.read('spec/seeds_recipies.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'recipies_directory_test' })
  connection.exec(seed_sql)
end

describe RecipeRepository do
  before(:each) do 
    reset_recipies_table
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._