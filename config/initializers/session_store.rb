# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_css_validator_session',
  :secret      => '5054527f7d00b4a146ebacc469eff9394f6db3b3e63c4e34f197967ba7eed7d58735f07e8040886a7ccba10b29c99b67aeecd3f1b09e6673a505f837c12eeeb4'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
