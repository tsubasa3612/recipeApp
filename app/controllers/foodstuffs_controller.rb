class FoodstuffsController < ApplicationController

	def index
		@foodstuffs = Foodstuff.all
	end

	def new
		@foodstuff = Foodstuff.new
	end

	def create
		@foodstuff = Foodstuff.new(foodstuff_params)
		if @foodstuff.save
			redirect_to projects_path
		else
			render 'new'
		end
	end

	def destroy
		@foodstuff = Foodstuff.find(params[:id])
		@foodstuff.destroy
		redirect_to projects_path
	end

	private
		def foodstuff_params
			params[:foodstuff].permit(:id, :title, :user_id)
		end
end
