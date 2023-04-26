require_relative 'recipe'

class RecipeRepository

  # Selecting all records
  # No arguments
  def all
    sql = 'SELECT id, name, cooking_time, rating FROM recipes;'
    result_set = DatabaseConnection.exec_params(sql, [])

    recipes = []

    result_set.each do |record|

      recipe = Recipe.new
      recipe.id = record['id'].to_i
      recipe.name = record['name']
      recipe.cooking_time = record['cooking_time'].to_i
      recipe.rating = record['rating'].to_i
      recipes << recipe
    end
    return recipes
  end

  # select a single album record given its id
  # id argument is an integer
  def find(id) 
    # executes the SQL
    # SELECT id, name, cooking_time, rating FROM recipes WHERE id =$1;
    # returns a single Recipe object
  end
end