class Publication < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy # el test me obligo hacer elim en cascada

  accepts_nested_attributes_for :comments, allow_destroy: true 
end

#para que los comentarios se borren en cascada
