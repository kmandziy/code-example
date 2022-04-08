# frozen_string_literal: true

module Statistics
  class PaginationService < BaseService
    def initialize(relation:, limit:, offset:)
      @relation = relation
      @limit = limit.to_i
      @offset = offset.to_i
    end

    attr_accessor :relation, :limit, :offset

    def call
      relation.metadata = metadata

      relation.prepared_sql_query = %(
        SELECT * FROM (#{relation.prepared_sql_query}) subquery
        LIMIT #{limit} OFFSET #{adjusted_offset}
      )
    end

    def adjusted_offset
      return 0 if offset == 1
      return ((limit * offset) - limit) if offset > 1
    end

    def metadata
      total = total_records_count

      {
        total: total,
        offset: offset,
        limit: limit,
        total_pages: total % limit == 0 ? total / limit : (total / limit).round + 1
      }
    end

    def total_records_count
      execute(
        %(SELECT COUNT(*) FROM (#{relation.prepared_sql_query}) query)
      ).to_a.first['count']
    end

    def execute(sql)
      ActiveRecord::Base.connection.execute(sql)
    end
  end
end
