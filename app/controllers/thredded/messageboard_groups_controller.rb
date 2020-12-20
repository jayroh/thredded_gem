# frozen_string_literal: true

module Thredded
  class MessageboardGroupsController < Thredded::ApplicationController

    def new
      @messageboard_group = Thredded::MessageboardGroup.new
      authorize @messageboard_group, :create?
    end

    def create
      @messageboard_group = Thredded::MessageboardGroup.new(messageboard_group_params)
      authorize @messageboard_group, :create?
      if @messageboard_group.save
        render json: MessageboardGroupSerializer.new(@messageboard_group).serializable_hash.to_json, status: 201
      else
        render json: {errors: @messageboard_group.errors }, status: 422
      end
    end

    def show
      @group = Thredded::MessageboardGroup.where(id: params[:id])
      @groups = Thredded::MessageboardGroupView.grouped(
        policy_scope(Thredded::Messageboard.where(group: params[:id])),
        user: thredded_current_user
      )
      render json: MessageboardGroupSerializer.new(@group).serializable_hash.to_json, status: 200
    end

    private

    def messageboard_group_params
      params
        .require(:messageboard_group)
        .permit(:name)
    end
  end
end
