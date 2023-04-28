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

end