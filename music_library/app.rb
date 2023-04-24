require_relative 'lib/database_connection'
require_relative 'lib/artist_repository'

DatabaseConnection.connect('music_library')

artist_repository = ArtistRepository.new

p artist_repository.all