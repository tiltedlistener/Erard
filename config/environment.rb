# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Lament::Application.initialize!

Lament::Application.config.user_salt = "S#!um6C=zm{l8|ZtDRm|TB"
Lament::Application.config.admin_salt = "v>MP4xn-DI0+,bUDFlYct@k7"
