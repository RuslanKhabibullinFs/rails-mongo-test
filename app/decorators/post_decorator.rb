class PostDecorator < ApplicationDecorator
  delegate :title, :content, :rating

  def assigned_categories
    object.categories.join(",")
  end
end
