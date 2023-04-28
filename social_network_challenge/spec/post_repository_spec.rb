require 'post_repository'

def reset_posts_table
  seed_sql = File.read('spec/seeds_posts.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
  connection.exec(seed_sql)
end

describe PostRepository do
  before(:each) do 
    reset_posts_table
  end

  it 'gets all the posts' do
    repo = PostRepository.new

    posts = repo.all

    expect(posts.length).to eq 2
    expect(posts.first.id).to eq 1
    expect(posts.first.title).to eq 'Hola'
    expect(posts.first.content).to eq 'blah blah'
    expect(posts.first.number_of_views).to eq 3
    expect(posts.first.account_id).to eq 1
  end

  it 'gets a single post' do
  
    repo = PostRepository.new

    posts = repo.find(1)

    expect(posts.title).to eq 'Hola'
    expect(posts.content).to eq 'blah blah'
    expect(posts.number_of_views).to eq 3
    expect(posts.account_id).to eq 1
  
  end

  it 'gets a different post' do
    repo = PostRepository.new

    posts = repo.find(2)

    expect(posts.title).to eq 'Mundo'
    expect(posts.content).to eq 'meh meh'
    expect(posts.number_of_views).to eq 2
    expect(posts.account_id).to eq 2
  end

end