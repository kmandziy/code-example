# frozen_string_literal: true

module Statistics
  class RecordRelation
    attr_accessor :query_object,
                  :prepared_sql_query,
                  :model_class,
                  :metadata,
                  :data

    delegate :model_class, :query, to: :query_object

    def initialize(query_object)
      @query_object = query_object
      @prepared_sql_query = @query_object.query
    end

    def execute_query
      @data = mapped_result
    end

    def mapped_result
      result.map do |res|
        object = model_class.new
        object.type = model_class.to_s

        res.each_key do |key|
          object.public_send("#{key}=", res[key])
        end

        object
      end
    end

    # [{id, ...}, ...]
    def result
      ActiveRecord::Base.connection.execute(prepared_sql_query).to_a
    end
  end
end
