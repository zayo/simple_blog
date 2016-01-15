class PostsController < ApplicationController

  before_action only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    if !current_user.nil?
      @posts = Post.eager_load(:user)
    else
      @posts = Post.where('is_private <> ?', true).eager_load(:user)
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.where('posts.id = ?', params[:id]).eager_load(:user, :pcomments).first
  rescue ActiveRecord::RecordNotFound
    @post = {}
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post         = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    new_params           = post_params
    new_params[:user_id] = @post.user_id
    if @post.update(new_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    redirect_to posts_url, notice: 'Post was successfully destroyed.'
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def post_params
    params.require(:post).permit(:user_id, :title, :description, :is_private, :options)
  end
end
