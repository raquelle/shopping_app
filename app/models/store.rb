class Store < ApplicationRecord
    has_many :lists, dependent: :destroy
    validates :name, presence: true
    validates :name, uniqueness: true

    def self.by_name
        order(:name)
    end
end
