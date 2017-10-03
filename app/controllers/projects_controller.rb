class ProjectsController < ApplicationController
	before_action :set_project, only: [:show, :edit, :update, :destroy]

	def index
		@projects = Project.all
        @foodstuffs = Foodstuff.all
        @user = current_user
	end

    def show
    end

    def new
    	@project = Project.new
    end

    def create
    	@project = Project.new(project_params)
    	if @project.save
    		redirect_to projects_path
    	else
    		render "new"
    	end
    end

    def edit
    end

    def update
    	if @project.update(project_params)
    		redirect_to projects_path
    	else
    		render "edit"
    	end
    end

    def destroy
    	@project.destroy
    	redirect_to projects_path
    end

    def recipe
        uri = URI.parse('https://app.rakuten.co.jp/services/api/Recipe/CategoryRanking/20170426?format=json&elements=recipiId%2CrecipeTitle%2CrecipeUrl%2CsmallImageUrl%2CrecipeMaterial&applicationId=1039136772752765175')
        json = Net::HTTP.get(uri)
        results = JSON.parse(json)
        # binding.pry

        #取得したjsonデータをDBに入れるための繰り返し処理
        results["result"].each do |r|
        # binding.pry
            Recipe.create!(title: r["recipeTitle"], url: r["recipeUrl"], image: r["smallImageUrl"])
                r["recipeMaterial"].each do |m|
        # binding.pry
                    Material.create!(name: m, recipe_id: material.recipe._id)
                end
        end

    end

    private

	    def project_params
	    	params[:project].permit(:id, :title, :user_id)
	    end

	    def set_project
	    	@project = Project.find(params[:id])
	    end
end