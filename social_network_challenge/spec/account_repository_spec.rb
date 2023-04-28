require 'account_repository'

def reset_accounts_table
  seed_sql = File.read('spec/seeds_accounts.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
  connection.exec(seed_sql)
end

describe AccountRepository do
  before(:each) do 
    reset_accounts_table
  end

  it "gets all the accounts" do
    repo = AccountRepository.new

    accounts = repo.all

    expect(accounts.length).to eq (2)
    expect(accounts.first.id).to eq (1)
    expect(accounts.first.user_name).to eq ("George")
    expect(accounts.first.email).to eq ("george@gmail.com")
  end

end

# it 'returns two albums' do
#   repo = AlbumRepository.new
#   albums = repo.all

#   albums = repo.all
#   expect(albums.length).to eq (2)
#   expect(albums.first.id).to eq (1)
#   expect(albums.first.title).to eq ('Doolittle')
#   expect(albums.first.release_year).to eq (1989)
# end