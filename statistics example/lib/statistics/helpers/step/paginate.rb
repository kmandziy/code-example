# frozen_string_literal: true

class Statistics::Helpers::Step::Paginate
  extend Uber::Callable

  def self.call(ctx, model:, params:, **)
    return unless ctx[:params][:metadata]

    Statistics::PaginationService.call(
      relation: model,
      limit: params.dig(:metadata, :limit),
      offset: params.dig(:metadata, :offset)
    )
  end
end
