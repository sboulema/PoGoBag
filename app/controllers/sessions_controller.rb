class SessionsController < ApplicationController
  rescue_from Poke::API::Errors::LoginFailure, :with => :login_error
  rescue_from ActionController::InvalidAuthenticityToken, :with => :logout_error

  def new
  end

  def create
    #Poke::API::Logging.log_level = :DEBUG

    # Log client in 
    client = Poke::API::Client.new
    @user = setup_client(client)
    name = @user.name

    # set session variable
    session[:pogo_alias] = name
    #session[:user][:username] = username
    #session[:user][:pass] = pass
    #session[:user][:auth] = auth
    #session[:user] = {username: username, password: pass, provider: auth}

    store_inventory(client, @user)

    flash[:success] = 'You logged in! Share your link with others: pogobag.me/'+name
    redirect_to user_link
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  protected
    def login_error
      flash.now[:danger] = 'Invalid user/password combination'
      render 'new'
    end
    def logout_error
      redirect_to 'new'
    end
end
