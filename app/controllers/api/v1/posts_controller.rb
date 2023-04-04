# app/controllers/api/v1/posts_controller.rb
module Api
  module V1
    class PostsController < ApplicationController
      before_action :authorize_request
      before_action :find_post, except: %i[create index]
      include JsonResponse
      before_action -> { check_user(@post) }, only: [:update, :destroy]
      def index
        posts = Post.all
        render json: {posts: posts.map{|post| post.attributes.merge(created_by: post.user.email, comments: post.comments, images: post.images.map{|image| {image: url_for(image)}}) }}, status: :ok
      end

      def create
        post = @current_user.posts.build(post_params)
        if post.save
          render json: post.attributes.merge(created_by: post.user), status: :created
        else
          unprocessable_entity_response(post)
        end
      end

      def show
        render json: { name: @post.name , description: @post.description, user: @post.user.email}, status: :ok
        #render json: @post, include: :user, status: :ok
        #render json: @post.as_json(only: [:name, :description]), status: :ok
      end

      def update  
        if @post.update(post_params)
          render json: @post.attributes.merge(updated_by: @current_user), status: :ok
        else
          unprocessable_entity_response(@post)
        end
      end

      def destroy
        @post.destroy
        render json: {message: "The Post is destroyed successfully"}
      end

      private

      def find_post
        @post = Post.find_by_id(params[:id])
      rescue ActiveRecord::RecordNotFound
         render json: { errors: 'Post not found' }, status: :not_found
      end

      def post_params
        params.permit(:name, :description, images: [])
      end
    end
  end
end


