require 'album_repository'

RSpec.describe AlbumRepository do
  
  def reset_albums_table
    seed_sql = File.read('spec/seeds_albums.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
    connection.exec(seed_sql)
  end

  before(:each) do
    reset_albums_table
  end
  
  it 'returns two albums' do
    repo = AlbumRepository.new
    albums = repo.all

    albums = repo.all
    expect(albums.length).to eq (2)
    expect(albums.first.id).to eq (1)
    expect(albums.first.title).to eq ('Doolittle')
    expect(albums.first.release_year).to eq (1989)
  end

  it 'returns a single album Doolittle' do
    repo = AlbumRepository.new
    album = repo.find(1)

    expect(album.title).to eq ('Doolittle')
    expect(album.release_year).to eq (1989)
    expect(album.artist_id).to eq (1) 
  end

  it 'returns a single album Surfer Rosa' do
    repo = AlbumRepository.new
    album = repo.find(2)

    expect(album.title).to eq ('Surfer Rosa')
    expect(album.release_year).to eq (1988)
    expect(album.artist_id).to eq (1) 
  end

  it 'creates a new album' do
    repo = AlbumRepository.new

    new_album = Album.new
    new_album.title = 'Syro'
    new_album.release_year = 2012
    new_album.artist_id = 9
  
    repo.create(new_album)

    # all albums should contain the new album
    all_albums = repo.all

    expect(all_albums).to include(
      have_attributes(
        title: new_album.title, 
        release_year: 2012,
        artist_id: 9  
      )
    )
  end

  it 'deletes album with id of 1' do
    
    repo = AlbumRepository.new

    id_to_delete = 1

    repo.delete(id_to_delete)

    all_albums = repo.all
    expect(all_albums.length).to eq (1)
    expect(all_albums.first.id).to eq (2)
  end

  it 'deletes both albums' do
    
    repo = AlbumRepository.new

    repo.delete(1)
    repo.delete(2)

    all_albums = repo.all
    expect(all_albums.length).to eq (0)
  end

  it 'updates an album with new values' do
    
    repo = AlbumRepository.new

    album = repo.find(1)
    album.title = 'something'
    album.release_year = 2019
    album.artist_id = 3

    repo.update(album)

    updated_album = repo.find(1)
    
    expect(updated_album.title).to eq 'something'
    expect(updated_album.release_year).to eq 2019
    expect(updated_album.artist_id).to eq 3
  end

  it 'updates an album with only one new value' do
    
    repo = AlbumRepository.new

    album = repo.find(1)
    album.title = 'something'

    repo.update(album)

    updated_album = repo.find(1)
    
    expect(updated_album.title).to eq 'something'
    expect(updated_album.release_year).to eq 1989

  end

end