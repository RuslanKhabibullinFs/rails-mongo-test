class Post
  include Mongoid::Document

  CATEGORIES = %w[literature math auto it philosophy].freeze

  validates :title, :content, presence: true
  validates :content, length: { minimum: 5 }
  validates :rating, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }
  validates :categories, presence: true

  field :title, type: String
  field :content, type: String
  field :rating, type: Integer, default: 0
  field :categories, type: Array
end
