class Export < ApplicationRecord
    validates :start_id, presence: true
    validates :end_id, presence: true

    has_and_belongs_to_many :companies, :join_table => :exports_companies
end
