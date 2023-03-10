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
    existing_companies = 0
    CSV.foreach(file.path, headers: true) do |row|
      company_name = row[0]
      website = row[1]
      company = Company.find_by(website: website)
      if company.nil?
        Company.create(company_name: company_name, website: website)
        count += 1
        puts "New company added. Total new added = #{count}"
      else
        existing_companies =+ 1
        puts "Company already exists in database. Total existing = #{existing_companies}"
      end
    end

    flash[:notice] = "Successfully added #{count} new entries to the database"
    redirect_to root_path

  end


  def update_emails
    api_key = ENV['hunter_io_api_key']
    companies = Company.where(email1: [nil, ""]).where(email2: [nil, ""])
    nodatacompanies = 0
    companies.each do |company|
      domain = company.website.gsub("https://", "").gsub("http://", "").split("/").first
      url = "https://api.hunter.io/v2/domain-search?domain=#{domain}&api_key=#{api_key}"
      response = Net::HTTP.get(URI(url))
      data = JSON.parse(response)
      if data["data"]["emails"].length > 0
        company.email1 = data["data"]["emails"][0]["value"]
        company.email2 = data["data"]["emails"][1]["value"] if data["data"]["emails"].length > 1
        company.instagram = data['instagram']
        company.state = data['state']
        company.save
      else
        nodatacompanies += 1
        puts "Company did not return any email data. Total = #{nodatacompanies}"
        company.destroy
      end
    end
    puts "#{nodatacompanies} companies deleted from database. They did not return email addresses from hunter."
  
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