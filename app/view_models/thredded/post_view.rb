# frozen_string_literal: true
module Thredded
  # A view model for PostCommon.
  class PostView
    delegate :filtered_content,
             :avatar_url,
             :created_at,
             :user,
             :to_model,
             :pending_moderation?,
             :approved?,
             :blocked?,
             :last_moderation_record,
             to: :@post

    # @param post [Thredded::PostCommon]
    # @param policy [#update? #destroy?]
    # @param policy [Thredded::TopicView]
    def initialize(post, policy, topic_view: nil)
      @post   = post
      @policy = policy
      @topic_view = topic_view
    end

    def can_update?
      @can_update ||= @policy.update?
    end

    def can_destroy?
      @can_destroy ||= @policy.destroy?
    end

    def can_moderate?
      @can_moderate ||= @policy.moderate?
    end

    def edit_path
      Thredded::UrlsHelper.edit_post_path(@post)
    end

    def mark_unread_path
      Thredded::UrlsHelper.mark_unread_path(@post)
    end

    def destroy_path
      Thredded::UrlsHelper.delete_post_path(@post)
    end

    def permalink_path
      Thredded::UrlsHelper.post_permalink_path(@post.id)
    end

    def read_state_class
      case read_state
      when :unread
        'thredded--unread--post'
      when :read
        'thredded--read--post'
      end
    end

    # rubocop:disable Metrics/CyclomaticComplexity
    def cache_key
      moderation_state = unless @post.private_topic_post?
                           if @post.pending_moderation? && !Thredded.content_visible_while_pending_moderation
                             'p'
                           elsif @post.blocked?
                             '-'
                           end
                         end
      [
        I18n.locale,
        @post.cache_key,
        (@post.messageboard_id unless @post.private_topic_post?),
        @post.user ? @post.user.cache_key : 'users/nil',
        read_state,
        moderation_state || '+',
        [
          can_update?,
          can_destroy?
        ].map { |p| p ? '+' : '-' } * ''

      ].compact.join('/')
    end
    # rubocop:enable Metrics/CyclomaticComplexity

    private

    def read_state
      if @topic_view.nil? || @policy.anonymous?
        :unknown
      elsif @topic_view.post_read?(@post)
        :read
      else
        :unread
      end
    end
  end
end
