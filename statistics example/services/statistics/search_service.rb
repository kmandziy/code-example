# frozen_string_literal: true

module Statistics
  class SearchService < BaseService
    def initialize(relation:, search_term:, search_columns: [])
      @relation = relation
      @search_term = search_term&.downcase
      @search_columns = search_columns
    end

    attr_accessor :relation, :search_term, :search_columns

    def call
      return unless search_term.present?

      relation.prepared_sql_query = %(
        SELECT * FROM (#{relation.prepared_sql_query}) subquery
        WHERE #{sql_like_clause}
      )
    end

    private

    def sql_like_clause
      search_columns.map { |column| like_clause_for_column(column) }
                    .join(" OR\n")
    end

    def like_clause_for_column(column_name)
      "LOWER(#{column_name}) LIKE '%#{search_term}%'"
    end
  end
end
