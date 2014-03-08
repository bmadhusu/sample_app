class SessionsController < ApplicationController

	def new
	end

	def create
	#	user = User.find_by(email: params[:session][:email].downcase)
		user = User.find_by(email: params[:email].downcase)
		if user && user.authenticate(params[:password])
			sign_in user
			redirect_to user
			# sign user in
		else
			flash.now[:error] = 'Invalid email/password combination'
			render 'new'
		end
	end

	def destroy
		sign_out
		redirect_to root_url
	end

end
