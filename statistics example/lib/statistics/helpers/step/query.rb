# frozen_string_literal: true

class Statistics::Helpers::Step::Query
  def self.Initialize(query_class: nil) # rubocop:disable Naming/MethodName
    step = lambda { |(options, _flow_options), **|
      Statistics::Helpers::Step::Query.initialize!(options, options['params'], query_class)
    }
    task = Trailblazer::Activity::TaskBuilder::Binary(step)
    { task: task, id: 'query.initialize' }
  end

  def self.Execute  # rubocop:disable Naming/MethodName
    step = lambda { |(options, _flow_options), **|
      Statistics::Helpers::Step::Query.execute!(options)
    }
    task = Trailblazer::Activity::TaskBuilder::Binary(step)
    { task: task, id: 'query.execute' }
  end

  def self.initialize!(options, params, query_class)
    query_object = query_class.new(filter: params.dig('metadata', 'filter'))
    options['model'] = Statistics::RecordRelation.new(query_object)
  end

  def self.execute!(options)
    options['model'].execute_query

    options['meta'] = options['model'].metadata
    options['model'] = options['model'].data
  end
end
