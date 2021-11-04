puts 'creating default user account--------------'
password_has = BCrypt::Password.create("knock_knock")
username = 'admin'
app_name = 'nlims'
location = 'lilongwe'
partner = 'api_admin'
token = 'xxxxxxx'
token_expiry_time = '000000000'

User.create(password: password_has,
                        username: username,
                        app_name: app_name,
                        partner: partner,
                        location: location,
                        token: token,
                        token_expiry_time: token_expiry_time
                )


puts '-------------done----------'

