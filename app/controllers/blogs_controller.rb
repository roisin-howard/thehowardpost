class BlogsController < ApplicationController

  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy] #user cannot access post creation page without being authenticated

  def index
    if params[:search]
      @blogs = Blog.search(params[:search]).order("created_at DESC")
    else
      @blogs = Blog.all.order('created_at DESC')
      @blogs_asc = Blog.all.order('created_at ASC')
      @blogs_by_month = Blog.all.group_by { |blog| blog.created_at.strftime("%B") }
    end
  end

  def show
    @blog = Blog.find_by_id(params[:id])
  end

  def new
    @blog = Blog.new
  end

  def create
    if user_signed_in?
      @blog = Blog.new(blog_params)
      @blog.user = current_user
      if @blog.save
          redirect_to @blog, notice: "Blog created!"
      else
        flash.now[:notice] = "Blog not created, could not save to database!"
        render 'new'
      end
    else
      redirect_to blogs_path, alert: "Blog not created, user not logged in!"
    end
  end

  def edit
    @blog = Blog.find(params[:id])
    unless current_user == @blog.user
      redirect_to @blog, alert: "You are not authorised to edit this blog!"
    end
  end

  def update
    @blog = Blog.find(params[:id])
    if @blog.update(blog_params)
      redirect_to blogs_path, notice: "Blog updated!"
    else
      flash.now[:notice] = "Blog not updated, could not save to database!"
      render 'edit'
    end
  end

  def destroy
    if(params[:arc] == "Archive")
      archive
      @blog = Blog.find(params[:id])
    else
      if current_user == @blog.user
    
        if @blog.deleted_at == nil    
          @blog.soft_delete
          redirect_to blog_path(@blog), alert: "Your blog was deleted!"

        elsif @blog.deleted_at != nil

          if(params[:del] == "Destroy")
            @blog.destroy
            redirect_to blogs_path, alert: "Your blog was permenantly deleted!"
          else
            @blog.undo_delete
            redirect_to blog_path(@blog), notice: "Your blog was restored!"
          end
        
        end
    
      else
        redirect_to @blog, alert: "You are not authorised to delete this blog!"
      end
    end
  end

  def archive
    puts "in archive at blog controller"
    @blog = Blog.find(params[:id])
    puts @blog
    if current_user == @blog.user
      puts current_user
      if !@blog.archived?
        puts "blog isnt already archived"
        @blog.archive
        redirect_to blogs_path, notice: "Your blog has been archived!"
      else
        redirect_to blog_path(@blog), notice: "Your blog is already archived!"
      end
    else
      redirect_to blog_path(@blog), alert: "You are not authorised to archive this blog!"
    end
  end

  private
    def blog_params
      puts params
      params.require(:blog).permit(:title, :body, :users_id, :status)
    end

end
