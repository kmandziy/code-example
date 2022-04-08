# frozen_string_literal: true

class Index < Trailblazer::Operation
  step ::Statistics::Helpers::Step::Query::Initialize(
    query_class: Statistics::Queries::SomeModels
  )

  pass ::Statistics::Helpers::Step::Order::Setup(fields: [:type, :year, :some_models_count,
                                                          :errors_count])
  pass ::Statistics::Helpers::Step::Paginate

  step ::Statistics::Helpers::Step::Query::Execute()
end
