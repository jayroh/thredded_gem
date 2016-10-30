# frozen_string_literal: true
module Thredded
  class TruthyHashSerializer
    class << self
      def dump(hash)
        hash.reject { |_k, v| v }.map { |k, _v| k }.join(',')
      end

      def load(s)
        return nil if s.nil?
        Hash.new(true).tap do |hash|
          s.split(',').each { |k| hash[k] = false }
        end
      end

      def create(hash = {})
        Hash.new(true).merge(hash)
      end
    end
  end
end