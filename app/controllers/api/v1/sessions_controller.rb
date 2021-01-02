class Api::V1::SessionsController < Devise::SessionsController

  before_action :sign_in_params, only: :create
  before_action :load_user, only: :create

  def create
    if @user.valid_password?(sign_in_params[:password])
      sign_in "user",@user
      json_response "Signed In Successfully",true,{user: @user}, :ok
    else
      json_response "Unauthorized",false,{},:Unauthorized

    end
  end

  #made_a_sessioncontroller class and updated post func in routes.

  private
  def sign_in_params
    params.require(:sign_in).permit(:email, :password)
  end

  def load_user
    @user = User.find_for_database_authentication(email: sign_in_params[:email])

    if @user
      return @user
    else
      json_response "Cannot find User",false,{},:failure
    end
  end
end
