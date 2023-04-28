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

  it 'gets all the accounts' do
    repo = AccountRepository.new

    accounts = repo.all

    expect(accounts.length).to eq (2)
    expect(accounts.first.id).to eq (1)
    expect(accounts.first.user_name).to eq ('George')
    expect(accounts.first.email).to eq ('george@gmail.com')
  end

  it 'gets the details of a single account' do
  
    repo = AccountRepository.new

    account = repo.find(1)

    expect(account.user_name).to eq 'George'
    expect(account.email).to eq 'george@gmail.com'
  
  end

  it 'gets the details of a different single account' do
  
    repo = AccountRepository.new

    accounts = repo.find(2)

    expect(accounts.user_name).to eq 'Aphra'
    expect(accounts.email).to eq 'aphra@gmail.com'
  
  end

  it 'creates a new account' do
  
    repo = AccountRepository.new

    new_account = Account.new
    new_account.user_name = 'Nathan'
    new_account.email = 'nathan@gmail.com'

    repo.create(new_account)

    all_accounts = repo.all

    expect(all_accounts).to include(
      have_attributes(
        user_name: 'Nathan', 
        email: 'nathan@gmail.com'
      )
    )  
  end

  it 'deletes one account' do
    repo = AccountRepository.new

    id_to_delete = 1

    repo.delete(id_to_delete)

    all_accounts = repo.all
    expect(all_accounts.length).to eq 1
    expect(all_accounts.first.id).to eq 2
  end

end