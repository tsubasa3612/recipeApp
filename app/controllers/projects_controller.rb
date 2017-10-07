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

        #カテゴリ取得APIを叩いてデータを取得する
        #取得したカテゴリIDを取り出す
        #取り出したカテゴリIDを並べる
        #並べたカテゴリIDをカテゴリ別ランキングAPIのURLのcategoryId=のところに入れられる形に整える
        #並べたカテゴリIDをカテゴリ別ランキングAPIのURLのcategoryId=のところに入れる
        #カテゴリ別ランキングAPIを叩いて取得したデータをDBに保存する
        #カテゴリ別ランキングの取得を全てのカテゴリIDで繰り返す

        #カテゴリ別ランキング取得apiを叩いてjsonデータを取ってきてパースする
        uri = URI.parse('https://app.rakuten.co.jp/services/api/Recipe/CategoryRanking/20170426?format=json&elements=recipiId%2CrecipeTitle%2CrecipeUrl%2CsmallImageUrl%2CrecipeMaterial&applicationId=1039136772752765175')
        # uri = URI.parse('https://app.rakuten.co.jp/services/api/Recipe/CategoryRanking/20170426?format=json&categoryId= + hoge + &elements=recipiId%2CrecipeTitle%2CrecipeUrl%2CsmallImageUrl%2CrecipeMaterial&applicationId=1039136772752765175')
        json = Net::HTTP.get(uri)
        results = JSON.parse(json)
        # binding.pry

        #パースしたjsonデータをDBに入れるための繰り返し処理
        results["result"].each do |r|
        # binding.pry
            recipe = Recipe.create!(title: r["recipeTitle"], url: r["recipeUrl"], image: r["smallImageUrl"]) # recipe = の変数宣言がないとエラー吐く
        # binding.pry
                r["recipeMaterial"].each do |m|
        # binding.pry
                    # recipe = Recipe.new
        # binding.pry
                    m = Material.create!(name: m, recipe_id: recipe.id)
        # binding.pry
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