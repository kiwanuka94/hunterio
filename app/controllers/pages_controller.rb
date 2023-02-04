class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:logout]

  def home
    @company_count = Company.count
    @company_success_count = Company.where.not(email1: [nil, ""]).or(Company.where.not(email2: [nil, ""])).count
    @company_outstanding_count = Company.where(email1: [nil, ""]).where(email2: [nil, ""]).count

  end

  def logout
    sign_out(current_user)
    redirect_to root_path
  end

  def page
    @page_key = request.path[1..-1]
    render "pages/#{@page_key}"
  end
end
