class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :must_login, only: [:new, :edit, :show]

  def index
    @posts = Post.page(params[:page]).per(5)
    @search = Post.ransack(params[:q])

    if params[:q].present?
     @search = Post.ransack(params[:q])
     @results = @search.result
    end

  end

  def show
    @post = Post.find_by(id: params[:id])
	@user = User.find_by(id: @post.user_id)
	@favorite = current_user.favorites.find_by(post_id: @post.id)
  end

  def new
    if params[:back]
      @post = Post.new(post_params)
	else
	  @post = Post.new
	end
  end

  def edit
  end

  def create
    @post = Post.new(post_params)
	@post.user_id = current_user.id
	@post.image.retrieve_from_cache! params[:cache][:image] if params[:cache][:image].present?
	@post.save!


    respond_to do |format|
      if @post.save
	    PostMailer.post_mail(@post).deliver
        format.html { redirect_to @post, notice: 'はいできました' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def confirm
    @post = Post.new(post_params)
	@post.user_id = current_user.id

	render :new if @post.invalid?
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
	  params.require(:post).permit(:content, :image, :image_cache, :user_id, :blog_id)
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
