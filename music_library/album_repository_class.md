# {{Albums}} Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

If the table is already created in the database, you can skip this step.

Otherwise, [follow this recipe to design and create the SQL schema for your table](./single_table_design_recipe_template.md).

*In this template, we'll use an example table `students`*

```
# EXAMPLE

Table: students

Columns:
id | name | cohort_name
```

## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
-- EXAMPLE
-- (file: spec/seeds_albums.sql)

-- Write your SQL seed here. 

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE albums RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO albums (title, release_year, artist_id) VALUES ('Doolittle', '1989', '1');
INSERT INTO albums (title, release_year, artist_id) VALUES ('Surfer Rosa', '1988', '1');
```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 your_database_name < seeds_{table_name}.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# EXAMPLE
# Table name: album

# Model class
# (in lib/album.rb)
class Album
end

# Repository class
# (in lib/album_repository.rb)
class AlbumRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: albums

# Model class
# (in lib/albums.rb)

class Album

  # Replace the attributes by your own columns.
  attr_accessor :id, :title, :release_year, :artist_id
end

# The keyword attr_accessor is a special Ruby feature
# which allows us to set and get attributes on an object,
# here's an example:
#
# student = Album.new
# album.title = 'Doolittle'
# album.release_year
```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table name: albums

# Repository class
# (in lib/albums_repository.rb)

class AlbumRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, title, release_year, artist_id FROM albums;

    # Returns an array of Album objects.
  end

  # select a single album record given its id
  # id argument is an integer
  def find(id) 
    # executes the SQL
    # SELECT id, title, release_year, artist_id FROM albums WHERE id =$1;
    # returns a single album object
  end

  # inserting a new album
  # album is a new album object
  def create(album)
    # INSERT INTO albums (title, release_year, artist_id) VALES($1, $2, $3)

    # returns nothing
  end

  # deletes an album
  # takes an id as an object argument
  def delete(id)
    # sql
    # DELETE FROM albums WHERE id = $1;

    # returns nothing
  end

  # updates an album
  # takes an album as the object argument 
  def update(album)
    # sql
    # UPDATE albums SET title = $1, release_year = $2, artist_id = $3 WHERE id = $4

    # returns nothing
  end

end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

# 1
# Get all students

repo = AlbumRepository.new

albums = repo.all

albums.length = 2
albums.first.id = "1"
albums.first.name = "Doolittle"

# 2
# get single album ('Doolittle')

repo = AlbumRepository.new

albums = repo.find(1)
album.title # => Doolittle
album.release_year # => 1989
album.artist_id # => '1'

# 3
# get single album ('Surfer Rosa')

repo = AlbumRepository.new

albums = repo.find(2)
album.title # => Surfer Rosa
album.release_year # => 1988
album.artist_id # => '1'

# 4
# insert a new album
repo = AlbumRepository.new

album = Album.new
album.title = 'Syro'
album.release_year = 2012
album.artist_id = 9

repo.create(album)

# all albums should contain the new album
all_albums = repo.all

last_album = albums.last
last_album.name = 'Syro'
last_album.release_year = 2012
last_album.artist.id = 9

# 5 
# delete album

repo = AlbumRepository.new

id_to_delete = 1

repo.delete(id_to_delete)

all_albums = repo.all
all_albums.length # => 1 (the seeds start the database with two)
all_albums.first.id # => 2

```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/album_repository_spec.rb

def reset_albums_table
  seed_sql = File.read('spec/seeds_albums.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end

describe StudentRepository do
  before(:each) do 
    reset_students_table
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._

