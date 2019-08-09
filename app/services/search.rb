# frozen_string_literal: true

class Services::Search
  AREAS = %w[Global Questions Answers Comments Users]

  def initialize(params)
    @resource = params[:resource]
    @query = params[:q]
  end

  def self.call(params)
    new(params).call
  end

  def call
    search_area.search @query
  end

  private

  def search_area
    AREAS.drop(1).include?(@resource) ? @resource.singularize.constantize : ThinkingSphinx
  end
end
