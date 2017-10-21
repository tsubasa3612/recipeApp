class ProjectsController < ApplicationController
	before_action :set_project, only: [:show, :edit, :update, :destroy]

	def index
        @user = current_user
        # @project = Project.find(params[:id])
        if params[:q].present?
            @search = Recipe.ransack(materials_name_eq_any: params[:q]["materials_name_cont"])
            @result = @search.result
        else
            params[:q] = nil
            @search = Recipe.ransack(params[:q])
        end
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
        #カテゴリ取得APIを叩いてjsonデータ取得
        uri = URI.parse('https://app.rakuten.co.jp/services/api/Recipe/CategoryList/20170426?format=json&elements=categoryId&categoryType=large&applicationId=1039136772752765175')
        json = Net::HTTP.get(uri)
        category = JSON.parse(json)
        sleep(2)
            category["result"]["large"].each do |c|
            sleep(2)
                #カテゴリ別ランキング取得apiを叩いてjsonデータ取得
                uri = URI.parse('https://app.rakuten.co.jp/services/api/Recipe/CategoryRanking/20170426?format=json&categoryId=' + c["categoryId"] + '&elements=recipiId%2CrecipeTitle%2CrecipeUrl%2CsmallImageUrl%2CrecipeMaterial&applicationId=1039136772752765175')
                json = Net::HTTP.get(uri)
                results = JSON.parse(json)
                    #パースしたjsonデータをDBに入れるための繰り返し処理
                    results["result"].each do |r|
                        recipe = Recipe.create!(title: r["recipeTitle"], url: r["recipeUrl"], image: r["smallImageUrl"]) # recipe = の変数宣言がないとエラー吐く
                        # require "open-uri"
                        # recipeimage = open(r["smallImageUrl"])
                        # Recipe.create!(image: recipeimage.read)
                            r["recipeMaterial"].each do |m|
                                m = Material.create!(name: m, recipe_id: recipe.id)
                            end
                    end
            end
    end

    def check_search

    end


    private

	    def project_params
	    	params[:project].permit(:id, :title, :user_id)
	    end

	    def set_project
	    	@project = Project.find(params[:id])
	    end


end