require_relative './post'

class PostRepository

  def all
    sql = 'SELECT id, title, content, number_of_views, account_id FROM posts;'
    result_set = DatabaseConnection.exec_params(sql, [])

    posts = []

    result_set.each do |record|   
      posts << record_to_post_object(record)
    end
    p posts
  end

  def find(id)
    sql = 'SELECT id, title, content, number_of_views, account_id FROM posts WHERE id =$1;'
    sql_params = [id]
    result = DatabaseConnection.exec_params(sql, sql_params)
    record = result[0]

    return record_to_post_object(record)

  end

  private

  def record_to_post_object(record)
    post = Post.new
    
    post.id = record['id'].to_i
    post.title = record['title']
    post.content = record['content']
    post.number_of_views = record['number_of_views'].to_i
    post.account_id = record['account_id'].to_i

    return post
  end
  

end