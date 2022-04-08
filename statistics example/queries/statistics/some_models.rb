# frozen_string_literal: true

module Statistics
  module Queries
    class SomeModel
      attr_accessor :filter

      FILTER_ATTRIBUTES = %i[start_date end_date some_model_type some_model_year].freeze

      FILTER_ATTRIBUTES.each do |property|
        define_method property do
          filter[property]
        end
      end

      def initialize(filter:)
        @filter = filter || {}
      end

      def model_class
        ::Statistics::SomeModel
      end

      # rubocop:disable Layout/LineLength
      def query
        %(
          SELECT some_models.type,
                 some_models.year,
                 COUNT(documents.id) as some_models_count,
                 AVG(some_models.initial_errors_count) as errors_count
          FROM some_models
            INNER JOIN documents ON some_models.document_id = documents.id
          WHERE documents.creation_type IS DISTINCT FROM 2
                       #{start_date.present? ? %( AND documents.created_at > '#{start_date}' ) : ''}
                       #{end_date.present? ? %( AND documents.created_at < '#{end_date}' ) : ''}
                       #{some_model_type.present? ? %( AND some_models.type = '#{some_model_type}' ) : ''}
                       #{some_model_year.present? ? %( AND some_models.year = #{some_model_year} ) : ''}
          GROUP BY some_models.year, some_models.type
        )
      end
      # rubocop:enable Layout/LineLength
    end
  end
end
