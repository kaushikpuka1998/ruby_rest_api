class Api::V1::SessionsController < Devise::SessionsController

  before_action :sign_in_params, only: :create
  before_action :load_user, only: :create
  before_action :valid_token, only: :destroy
  skip_before_action :verify_signed_out_user, only: :destroy


  #Sign Process
  def create
    if @user.valid_password?(sign_in_params[:password])
      sign_in "user",@user
      json_response "Signed In Successfully",true,{user: @user}, :ok
    else
      json_response "Unauthorized",false,{},:unauthorized

    end
  end

  #logout
  def destroy
    sign_out @user
    @user.generate_unique_authentication_token
    json_response "Successfully Logged out",true,{}, :ok

  end

  #made_a_sessioncontroller class and updated post func in routes.

  private
  def sign_in_params
    params.require(:sign_in).permit(:email, :password)
  end


  #loading user data from email
  def load_user
    @user = User.find_for_database_authentication(email: sign_in_params[:email])

    if @user
      return @user
    else
      json_response "Cannot find User", false, {}, :unprocessable_entity
    end
  end

  #Checking Valid Token or not
  def valid_token
    @user = User.find_by authentication_token: request.headers["AUTH-TOKEN"]
    if @user
      return @user
    else
      json_response "Invalid Token", false, {},:unprocessable_entity
    end
  end
end
