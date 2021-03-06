# frozen_string_literal: true

class WelcomeController < ApplicationController
  def index
    return if params[:url].blank?

    @url = params[:url]
    sample = Sample.new
    @result = sample.issues(@url)
    @message = sample.message if sample.message.present?
  end
end
