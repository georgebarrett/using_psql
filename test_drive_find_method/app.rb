# file: app.rb

require_relative 'lib/database_connection'

# We need to give the database name to the method `connect`.
DatabaseConnection.connect('recipes_directory')

require_relative 'lib/database_connection'
require_relative 'lib/recipe_repository'

DatabaseConnection.connect('recipes_directory')

recipe_repository = RecipeRepository.new


recipe_repository.all.each do |recipe|
 p "id: #{recipe.id}, name: #{recipe.name}, cooking time: #{recipe.cooking_time} minutes, rating: #{recipe.rating} out of 5 "
end

# recipe = recipe_repository.find(1)

# puts recipe.id
# puts recipe.name
# puts recipe.cooking_time
# puts recipe.rating