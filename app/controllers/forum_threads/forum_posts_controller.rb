class ForumThreads::ForumPostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_forum_thread
  before_action :set_post_params, except: [:create, :new]
  before_action :own_auth, only: [:update, :edit, :destroy]
    # GET /forum_posts
  # GET /forum_posts.json


  def create
    @forum_post = @forum_thread.forum_posts.new set_post_params
    @forum_post.user = current_user
    if @forum_post.save
      @forum_post.send_notification!
      redirect_to forum_thread_path(@forum_thread,anchor: "forum_post_#{@forum_post.id}"), notice: "Created the Post"
    end
  end

  def edit
  end

  def update
    @forum_post.update(params.require(:forum_post).permit(:body))
    redirect_to forum_thread_path(@forum_thread,anchor: "forum_post_#{@forum_post.id}"), notice: "Updated the Post"
  end

  def destroy
  end

  private
    def set_post_params
      params.require(:forum_post).permit(:body)
    end

    def set_forum_thread
      @forum_thread = ForumThread.find(params[:forum_thread_id])
    end

    def set_post_params
      @forum_post = @forum_thread.forum_posts.find(params[:id])
    end

    def own_auth
      if !current_user.admin? && current_user != ForumPost.find(params[:id]).user
        redirect_to forum_thread_path(params[:forum_thread_id]), notice: "You cannot do this"
      end
    end

end
