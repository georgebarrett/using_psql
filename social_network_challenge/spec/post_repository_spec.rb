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

  it 'creates a new post' do
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
  end

  it 'deletes a post' do
    repo = PostRepository.new

    id_to_delete = 1

    repo.delete(id_to_delete)

    all_posts = repo.all
    expect(all_posts.length).to eq 1 
    expect(all_posts.first.id).to eq 2
  end

  it 'deletes multiple posts' do
    repo = PostRepository.new

    repo.delete(1)
    repo.delete(2)

    all_posts = repo.all
    expect(all_posts.length).to eq (0)
  end

  it 'updates an entire post' do
    repo = PostRepository.new

      post = repo.find(1)
      post.title = 'something'
      post.content = 'something something what'
      post.number_of_views = 6
      post.account_id = 1

      repo.update(post)

      updated_post = repo.find(1)
      updated_post.title = 'something'
      updated_post.content = 'something something what'
      updated_post.number_of_views = 6
      updated_post.account_id = 1
  end

  it 'updates a single value in a post' do
    repo = PostRepository.new

    post = repo.find(1)
    post.title = 'something'

    repo.update(post)

    updated_post = repo.find(1)

    expect(updated_post.title).to eq 'something'
    expect(updated_post.content).to eq 'blah blah'
    expect(updated_post.number_of_views).to eq 3
    expect(updated_post.account_id).to eq 1
  end

end