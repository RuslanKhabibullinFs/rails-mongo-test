class PostFilterQuery
  ALLOWED_PARAMS = %w[categories rating_filtration_value rating_sort_direction].freeze
  DEFAULT_ORDER_DIRECTION = :desc

  attr_reader :relation, :filter_params
  private :relation, :filter_params

  def initialize(relation, filter_params = {})
    @relation = relation
    @filter_params = filter_params
  end

  def all
    return relation if sliced_params.empty?

    %i[filtered_by_category filter_by_rating sort_by_rating].reduce(relation) do |relation, key|
      send(key, relation)
    end
  end

  private

  def filter_by_rating(relation)
    return relation if rating.blank?

    relation.where(rating: rating)
  end

  def sort_by_rating(relation)
    return relation unless %i[desc asc].include? sort_direction

    relation.public_send(sort_direction, :rating)
  end

  def filtered_by_category(relation)
    relation.where(:categories.in => categories).unwind("$categories")
  end

  def categories
    sliced_params["categories"].blank? ? Post::CATEGORIES : sliced_params["categories"]
  end

  def sort_direction
    return DEFAULT_ORDER_DIRECTION if sliced_params["rating_sort_direction"].blank?
    sliced_params["rating_sort_direction"].to_sym
  end

  def rating
    sliced_params["rating_filtration_value"]
  end

  def sliced_params
    filter_params.slice(*ALLOWED_PARAMS).to_h
  end
end
