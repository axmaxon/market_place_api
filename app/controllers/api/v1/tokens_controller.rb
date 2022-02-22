class Api::V1::TokensController < ApplicationController
  # По email извлекает юзера; используя метод authenticate
  # (ставший доступным с установкой bcrypt), сравнивает хэши паролей
  # из params и из поля password_digest;
  # Если пользователь аутентифицирован - возвращается токен аутентификации
  # сгенерированный классом JsonWebToken
  def create
    @user = User.find_by_email(user_params[:email])

    if @user&.authenticate(user_params[:password])
      render json: { token: JsonWebToken.encode(user_id: @user.id), email: @user.email }
    else
      head :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
