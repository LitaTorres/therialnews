class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :publications
  has_many :comments
  enum :role, [:normal_user, :author, :admin] #para q los numeros se conviertan en palabras
end
