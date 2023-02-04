class ExportController < ApplicationController

    def create
        @export = Export.new(export_params)
        if @export.save
          session[:export_id] = @export.id
          redirect_to export_download_path
        else
          redirect_to root_path, alert: "Export failed"
        end
    end
    
    def download
        export = Export.find(session[:export_id])
        csv_string = export_file(export.start_id, export.end_id)
        send_data(csv_string, type: 'text/csv', filename: 'companies_export.csv',
                  disposition: 'attachment')
    end


    def export_file(start_id, end_id)
        companies = Company.where(id: start_id..end_id)
        csv_string = CSV.generate do |csv|
          csv << ["CompanyName", "Website", "Email 1", "Email 2", "InstagramHandle", "State"]
          companies.each do |company|
            csv << [company.company_name, company.website, company.email1, company.email2, company.instagram, company.state]
          end
        end
        csv_string
    end

    
    private
    
    def export_params
        params.permit(:start_id, :end_id)
    end
            

end