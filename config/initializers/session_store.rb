# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_dvdpost_session',
  :secret      => 'e906d02d97cac9f07d59d598bb7aa77a9cd1c01d60e98c9af183ea74c0a13b6a8aa1ed5a8f2f60c8871f60fa7377c5c2aa0439f5ac9e75134eec9f87b97546f3'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
ActionController::Base.session_store = :active_record_store
