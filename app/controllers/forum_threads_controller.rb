class ForumThreadsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_forum_thread, except: [:index, :new, :create,:update]
  before_action :own_auth, only: [:update, :edit, :destroy]
  def index
    #@q = ForumThread.search(params[:q])
    #@user = Octokit.user 'therise3107'
    #@issues = Octokit.issues 'rails/rails', :per_page => 100
    #@issues.concat Octokit.last_response.rels[:next].get.data
    @q = ForumThread.search(params[:q])
    @forum_threads = @q.result(distinct: true)#@q.result(distinct: true)
  end

  def show
    @forum_post = ForumPost.new

  end

  def new
    @forum_thread = ForumThread.new
    @forum_thread.forum_posts.new

  end

  def edit
  end



  def create
    @forum_thread = ForumThread.new forum_thread_params
    @forum_thread.owner = current_user
    @forum_thread.forum_posts.last.user_id = current_user.id
    if @forum_thread.save
      redirect_to forum_thread_path(@forum_thread)
    else
      render action: :new
    end
  end

  def update
    @forum_thread.update(params.require(:forum_thread).permit(:subject))
    redirect_to @forum_thread
  end
  def destroy
    @forum_thread = ForumThread.find(params[:id])
    @forum_thread.destroy
    render action: :index
  end

  private

    def set_forum_thread
      @forum_thread = ForumThread.find(params[:id])
    end

    def forum_thread_params
      params.require(:forum_thread).permit(:subject, forum_posts_attributes: [:body])
    end
    def own_auth
      if !current_user.admin? && current_user != ForumThread.find(params[:id]).user
        redirect_to root_path, notice: "You cannot do this"
      end
    end
end
