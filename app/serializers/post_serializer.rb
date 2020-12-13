# frozen_string_literal: true

class PostSerializer
  include FastJsonapi::ObjectSerializer
  set_type :post
  attributes :user_id, :content, :source, :postable_id, :messageboard_id, :moderation_state, :created_at, :updated_at
  belongs_to :user
end