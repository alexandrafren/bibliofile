require 'bundler'
Bundler.require

require_all 'app'

ActiveRecord::Base.establish-connection(
  :adapter => "sqlite3",
  :database => "db/development.sqlite"
)
