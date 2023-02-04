class Company < ApplicationRecord
    has_many :exports_companies, dependent: :destroy
    has_many :exports, through: :exports_companies
end
