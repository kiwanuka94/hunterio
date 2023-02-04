class ExportsCompany < ApplicationRecord
  belongs_to :export
  belongs_to :company
end
