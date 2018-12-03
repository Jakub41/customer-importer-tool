# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def after_sign_in_path_for(user)
    root_path
  end

  def after_resetting_password_path_for(user)
    after_sign_in_path_for(user)
  end
end
