# frozen_string_literal: true

module AwsInfraMapper
  module Services
    module Aws
      class BaseService
        def initialize
          @filters = []
        end

        def add_vpc_filter(vpc_ids)
          add_filter_with_name('vpc-id', vpc_ids)
        end

        def add_raw_filter(filter)
          @filters << filter
        end

        def generic_client_args
          args = {}
          args[:filters] = @filters unless @filters.empty?

          args
        end

        def self.object_meta_dict(object)
          object.to_h.merge!(BaseService.tag_for_rendering(object))
        end

        def self.tag_for_rendering(object)
          return {} unless object.respond_to? :tags

          object.tags.each_with_object({}) do |tag, h|
            h.store("tag_#{tag.key}", tag.value)
            h
          end
        end

        private

        def add_filter_with_name(name, filter_values)
          @filters << {
            name: name,
            values: filter_values
          }
        end
      end
    end
  end
end
