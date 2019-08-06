class SearchController < ApplicationController
  def results
    @query = q_params

    if @query[:q].blank?
      redirect_to root_path, alert: "Empty search field!" and return
    else
      @results = Services::Search.call(@query)
    end
  end

  private

  def q_params
    params.permit(:q, :resource)
  end
end
