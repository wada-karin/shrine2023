class PostsController < ApplicationController
    before_action :authenticate_user!, only: [:new, :create]
    def index
        if params[:search].present?
            search = params[:search]
            @posts = Post.joins(:user).where("name LIKE ?", "%#{search}%")
          else
            @posts = Post.all
          end
          if params[:tag_ids]
            @posts = []
            params[:tag_ids].each do |key, value|      
              @posts += Tag.find_by(name: key).posts if value == "1"
            end
            @posts.uniq!
          end
          if params[:tag]
            Tag.create(name: params[:tag])
          end
    end

    def new
        @post = Post.new
      end
    
      def create
        post = Post.new(post_params)
        post.user_id = current_user.id
        if post.save!
          redirect_to :action => "index"
        else
          redirect_to :action => "new"
        end
      end
      def show
        @post = Post.find(params[:id])
      
      @comments = @post.comments
      @comment = Comment.new
      end

      def edit
        @post = Post.find(params[:id])
      end
      def update
        post = Post.find(params[:id])
        if post.update(post_params)
          redirect_to :action => "show", :id => post.id
        else
          redirect_to :action => "new"
        end
      end
      def destroy
        post = Post.find(params[:id])
       post.destroy
        redirect_to action: :index
      end

      private
      def post_params
        params.require(:post).permit(:name, :address, :about,:image,tag_ids: [])
      end
end
