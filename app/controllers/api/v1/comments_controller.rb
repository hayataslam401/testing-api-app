# app/controllers/api/v1/posts_controller.rb
module Api
  module V1
    class CommentsController < ApplicationController
      before_action :authorize_request
      before_action :find_comment, except: %i[create index]
      include JsonResponse
      before_action -> { check_user(@comment) }, only: [:update, :destroy]
      def index
        comments = Comment.all
        render json: {comments: comments.map{|comment| {comment: comment.body, commented_by: comment.user.email, Post: comment.post.name} }}, status: :ok
      end

      def create
        comment = @current_user.comments.build(comment_params)
        if comment.save
          render json: comment.attributes.merge(commented_by: comment.user.email, Post: comment.post.name), status: :created
        else
          unprocessable_entity_response(comment)
        end
      end

      def show
        render json: { body: @comment.body , rating: @comment.rating, post: @comment.post.name}, status: :ok
      end

      def update
        if @comment.update(comment_params)
          render json: @comment.attributes.merge(updated_by: @current_user), status: :ok
        else
          unprocessable_entity_response(@comment)
        end
      end

      def destroy
        @comment.destroy
        render json: {message: "The Comment is destroyed successfully"}
      end


      private

      def find_comment
        @comment = Comment.find_by_id(params[:id])
      rescue ActiveRecord::RecordNotFound
         render json: { errors: 'Comment not found' }, status: :not_found
      end



      def comment_params
        params.permit(:body, :rating, :post_id)
      end
    end
  end
end


