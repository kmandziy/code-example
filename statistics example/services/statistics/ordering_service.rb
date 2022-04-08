# frozen_string_literal: true

module Statistics
  class OrderingService < BaseService
    def initialize(relation:, sorts_object:, order_columns: [])
      @relation = relation
      @sorts_object = sorts_object
      @order_columns = order_columns
    end

    attr_accessor :relation, :sorts_object, :order_columns

    def call
      return unless sorts_object && order_column?

      relation.prepared_sql_query = %(
        SELECT * FROM (#{relation.prepared_sql_query}) subquery
        ORDER BY #{column_name} #{column_order}
      )
    end

    private

    def order_column?
      order_columns.include?(column_name.to_sym)
    end

    def column_name
      @column_name ||= sorts_object.keys.first
    end

    def column_order
      sorts_object[column_name]
    end
  end
end
