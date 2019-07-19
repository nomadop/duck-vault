json.extract! account, :id, :type, :sub_type, :merchant, :change, :currency, :comments, :datetime, :created_at, :updated_at
json.url account_url(account, format: :json)
json.username account.user.username
