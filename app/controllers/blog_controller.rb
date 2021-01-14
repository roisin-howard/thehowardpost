class BlogController < ApplicationController
  def index
    @blogs = Blog.all.order("created_at DESC");
  end

  def show
    @blog = Blog.find_by_id(params[:id])
  end

  def new
    puts "New"
    @blog = Blog.new
    puts "Hello"
  end

  def create
    puts "hello"
    if user_signed_in?
      puts "logged in"
      @blog = Blog.new(blog_params)
      puts @blog
      @blog.users_id = current_user.id
      if @blog.save
          redirect_to @blogs
      else 
      render json: {  
          status: 500,
          errors: ['blog not created']
      }
      end
    else
      render json: {
          status: 500,
          errors: ['user not logged in']
      }
    end
  end

  def edit
    @blog = Blog.find(params[:id])
  end

  def update
    @blog = Blog.find(params[:id])

    if @blog.update(blog_params)
      redirect_to @blog
    else
      render :edit
    end
  end

  private
    def blog_params
      params.require(:blog).permit(:title, :body)
    end

end
