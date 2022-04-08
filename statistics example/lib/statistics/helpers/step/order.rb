# frozen_string_literal: true

class Statistics::Helpers::Step::Order
  def self.Setup(fields: nil) # rubocop:disable Naming/MethodName
    step = lambda { |(options, _flow_options), **|
      Statistics::Helpers::Step::Order.order!(options, options['params'], fields)
    }

    task = Trailblazer::Activity::TaskBuilder::Binary(step)
    { task: task, id: 'model.ordering' }
  end

  def self.order!(options, params, fields)
    Statistics::OrderingService.call(
      relation: options['model'],
      sorts_object: params.dig('metadata', 'sorts'),
      order_columns: fields
    )
  end
end
