class HomeController < ApplicationController
  def index
    if params[:code]
      session[:access_token] = session[:oauth].get_access_token(params[:code])
    end

    @api = Koala::Facebook::API.new(session[:access_token])

    begin
      puts session[:access_token]
      @user_profile = @api.get_object("me")
      friends = @api.get_connections("me", "friends")
      puts friends
    rescue Exception=>ex
      puts ex.message
      redirect_to '/login' and return
    end

    respond_to do |format|
      format.html {   }
    end
  end

  def login
      session[:oauth] = Koala::Facebook::OAuth.new(APP_ID, APP_SECRET, SITE_URL + '/')
      @auth_url =  session[:oauth].url_for_oauth_code(:permissions=>"read_stream publish_stream")  

      redirect_to @auth_url
  end
end
