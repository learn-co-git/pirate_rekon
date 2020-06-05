module Helpers
  def self.current_user(session)
    @user = User.find(session["user_id"])
  end

  def self.is_logged_in?(session)
    !session["user_id"].nil?
  end

  def self.confirm_user(session)
    @user.id == session[:user.id]
  end
end
