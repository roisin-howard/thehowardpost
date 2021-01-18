class CommentsController < ApplicationController
  def new
    @comment = Comment.new
  end

  def create
    if user_signed_in?
      @comment = Comment.new(comment_params)
      @blog = Blog.find_by_id(@comment.blog_id)
      @comment.blog = @blog
      if @comment.save
          redirect_to @blog, notice: "Comment created!"
      else
        render blog_path
      end
    else
      redirect_to blogs_path, alert: "Comment not created, user not logged in!"
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @blog_id = @comment.blog_id
    @comment.destroy
    redirect_to blog_path(:id => @blog_id), notice: "Comment deleted!"
  end
  
  private
    def comment_params
      params.require(:comment).permit(:commenter, :body, :blog_id)
    end
end
