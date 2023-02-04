class Company < ApplicationRecord
    scope :ordered_by_id, -> { order(:id) }
    scope :offset_limit, -> (offset, limit) { ordered_by_id.offset(offset).limit(limit) }
    
    has_and_belongs_to_many :exports, :join_table => :exports_companies
end
