class Export < ApplicationRecord
    validates :start_id, presence: true
    validates :end_id, presence: true

    has_many :exports_companies, dependent: :destroy
    has_many :companies, through: :exports_companies
end
