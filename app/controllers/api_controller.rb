class ApiController < ApplicationController
    include HTTParty
    
    API_KEY = 'd80aba1759128ccaf68f3d525483d6e880cb2823'

    def search_domain
        domain = params[:domain]
        api_key = params[:api_key]
        response = HTTParty.get("https://api.hunter.io/v2/domain-search?domain=#{domain}&api_key=#{api_key}")
    
        render json: response
      end
    

    def data
        #get website, and company name info, feed into search domain function
    end



  end