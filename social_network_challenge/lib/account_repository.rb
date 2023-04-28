require_relative './account'

class AccountRepository

  def all 

    accounts = []

    sql = 'SELECT id, user_name, email FROM accounts;'
    result_set = DatabaseConnection.exec_params(sql, [])

    result_set.each do |record|   
      account = Account.new

      account.id = record["id"].to_i
      account.user_name = record["user_name"]
      account.email = record["email"]
    
      accounts << account
    end
    return accounts
  end

  def find(id)
    sql = 'SELECT id, user_name, email FROM accounts WHERE id =$1;'
    sql_params = [id]
    result = DatabaseConnection.exec_params(sql, sql_params)
    record = result[0]

    return record_to_acount_object(record)
  end

  def create(account)
    sql = 'INSERT INTO accounts (user_name, email) VALUES($1, $2);'
    sql_params = [account.user_name, account.email]
    result = DatabaseConnection.exec_params(sql, sql_params)

    return nil
  end

  def delete(id)
    sql = 'DELETE FROM accounts WHERE id = $1;'
    sql_params = [id]
    result = DatabaseConnection.exec_params(sql, sql_params)

    return nil
  end

  private

  def record_to_acount_object(record)
    account = Account.new
    
    account.id = record['id'].to_i
    account.user_name = record['user_name']
    account.email = record['email']

    return account
  end

end