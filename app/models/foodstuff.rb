class Foodstuff < ApplicationRecord
	validates :title, presence: { message: "入力してください" },
	length: { minimum: 3, message: "短すぎます" }
	belongs_to :user
end
