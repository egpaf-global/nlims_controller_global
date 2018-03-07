
module UserService


	def self.create_user(params)
		location = params[:location]
        app_name = params[:app_name]
        password = params[:password]
        username = params[:username]
        token = params[:token]
        partner = params[:partner]

        details  = compute_expiry_time
        token = details[:token]
        expiry_time = details[:expiry_time]
        password = encrypt_password(password)

        User.create(app_name: app_name, 
        			partner: partner, 
        			location: location, 
        			password: password, 
        			username: username,
        			token: token,
        			token_expiry_time: expiry_time 
        		)

        return {token: token, expiry_time: expiry_time}
	end


	def self.create_token
		token_chars  = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
  		token_length = 12
  		token = Array.new(token_length) { token_chars[rand(token_chars.length)] }.join
		return token
	end
 

	def self.compute_expiry_time

   		token = create_token
   		time = Time.now 
   		time = time + 14400
		return {token: token, expiry_time: time.strftime("%Y%m%d%H%M%S")}
	end


	def self.check_token(token)
		user = User.where(token: token).first

		if user 
			if user.token_expiry_time > Time.now.strftime("%Y%m%d%H%M%S")
				return true
			else
				return false
			end
		else
			return false
		end

	end


	def self.authenticate(username,password)

		user = User.where(username: username)
		
		if user 
			secured_pass =  BCrypt::Password.new(user[0]['password'])
			if secured_pass == password
				return true
			else
				return false
			end
		else
			return false
		end
	end


	def self.check_user(username)
		user = User.where(username: username).first
		if user
			return true
		else
			return false
		end

	end


	def self.re_authenticate(username,password)
		user = User.where(username: username).first
		token = create_token
		expiry_time = compute_expiry_time
		if user
			secured_pass = decrypt_password(user.password)
			if secured_pass == password
				User.update(user.id,token: token, token_expiry_time: expiry_time[:expiry_time])
				return {token: token, expiry_time: expiry_time[:expiry_time]}
			else
				return false
			end
		else
			return false
		end

	end


	def self.encrypt_password(password)

		return BCrypt::Password.create(password)
	end


	def self.decrypt_password(password)
		return BCrypt::Password.new(password)
	end

end
