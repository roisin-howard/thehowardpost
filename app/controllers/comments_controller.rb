class CommentsController < ApplicationController
    def create
        @blog = Blog.find_by_id(params[:id])
        @comment = @blog.comments.create(comment_params)
        redirect_to blogs_path(@blog)
    end

    def destroy
        @blog = Blog.find_by_id(params[:id])
        @comment = @blog.comments.find(params[:id])
        @comment.destroy
        redirect_to blogs_path(@blog)
    end
    
      private
        def comment_params
          params.require(:comment).permit(:commenter, :body, :blog_id)
        end
end
