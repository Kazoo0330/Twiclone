class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  before_action :must_login, only: [:new, :edit, :show]
  def index
    # @posts = Post.all.order(created_at: :desc)
	  @posts = Post.page(params[:page]).per(5)
	  # @posts = Post.paginate(page: params[:page])
   @search = Post.ransack(params[:q])

   if params[:q].present?
     @search = Post.ransack(params[:q])
     @results = @search.result
    end
  # elsif params[:q].nill?

  end

  def show
    @post = Post.find_by(id: params[:id])
	@user = User.find_by(id: @post.user_id)
	@favorite = current_user.favorites.find_by(post_id: @post.id)
  end

  def new
    @post = Post.new
  end

  def edit
  end

  def create
    @post = Post.new(post_params)
	@post.user_id = current_user.id 

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'はいできました' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'かきかえた' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'けしたよ' }
      format.json { head :no_content }
    end
  end

  def ensure_current_user 
    @post = Post.find_by(id:params[:id])
	  if @post.user_id != @current_user.id 
	    flash[:notice] = 'ちがうだろ？'
		reidrect_to("/posts/index")
	  end
  end

  private
    def post_params
	  params.require(:post).permit(:content, :user_id, :blog_id)
	end

    def set_post
      @post = Post.find(params[:id])
    end

	def must_login
	  unless !current_user.nil?
	    redirect_to posts_path, notice: "ログインしないでいけると思ってんの？"
	  end
	end
end
