# frozen_string_literal: true

class Statistics::Helpers::Step::Search
  def self.Setup(fields: nil) # rubocop:disable Naming/MethodName
    step = lambda { |(options, _flow_options), **|
      Statistics::Helpers::Step::Search.search!(options, options['params'], fields)
    }

    task = Trailblazer::Activity::TaskBuilder::Binary(step)
    { task: task, id: 'model.search' }
  end

  def self.search!(options, params, fields)
    search_params = params.dig('metadata', 'filter', 'search_term')
    return unless search_params

    Statistics::SearchService.call(
      relation: options['model'],
      search_term: search_params,
      search_columns: fields
    )
  end
end
