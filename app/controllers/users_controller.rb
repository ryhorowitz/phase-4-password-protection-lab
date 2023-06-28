class UsersController < ApplicationController
  before_action :authorize, only: [:show]

  def show
    user = User.find(session[:user_id])

    render json: user, status: :ok
  end

  def create
    user = User.create(user_params)
    if user.valid?
      session[:user_id] = user.id
      render json: user, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:username, :password, :password_confirmation)
  end

  def authorize
    return render json: { error: "Not_authorized" }, status: :unauthorized unless session.include? :user_id
  end
end
