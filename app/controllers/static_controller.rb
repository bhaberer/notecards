# frozen_string_literal: true

class StaticController < ApplicationController
  def index
    return unless user_signed_in?

    redirect_to home_path
  end

  def notfound; end
end
