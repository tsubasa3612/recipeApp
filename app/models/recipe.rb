class Recipe < ApplicationRecord
	has_many :materials
	validates :title , uniqueness: true 

end
