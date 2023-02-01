require 'csv'

class HomeController < ApplicationController

  def create
    file = params[:file]

    if !file.present? || !validate_csv(file)
      flash[:alert] = "Please upload a valid CSV file with the correct headers"
      redirect_to root_path and return
    end

    # Do your processing here
    file = params[:file]
    count = 0
    CSV.foreach(file.path, headers: true) do |row|
      company_name = row[0]
      website = row[1]
      company = Company.find_by(company_name: company_name)
      if company.nil?
        Company.create(company_name: company_name, website: website)
        count += 1
      end
    end

    flash[:notice] = "Successfully added #{count} new entries to the database"
    redirect_to root_path

  end

  

  def update_emails
    api_key = "d80aba1759128ccaf68f3d525483d6e880cb2823"
    companies = Company.where(email1: nil, email2: nil)
    companies.each do |company|
      domain = company.website.gsub("https://", "").gsub("http://", "").split("/").first
      url = "https://api.hunter.io/v2/domain-search?domain=#{domain}&api_key=#{api_key}"
      response = Net::HTTP.get(URI(url))
      data = JSON.parse(response)
      company.email1 = data["data"]["emails"][0]["value"] if data["data"]["emails"].length > 0
      company.email2 = data["data"]["emails"][1]["value"] if data["data"]["emails"].length > 1
      company.save
    end

    flash[:notice] = "Successfully updated emails for all companies in the database without emails"
    redirect_to root_path
  end

  private

  def validate_csv(file)
    headers = ["company_name", "website"]
    
    begin
      csv = CSV.parse(file.read, headers: true)
    rescue CSV::MalformedCSVError
      return false
    end

    csv.headers == headers
  end

end