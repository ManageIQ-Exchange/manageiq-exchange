class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :trackable,
         :token_authenticatable # For tiddle usage
         # :recoverable, :rememberable, :validatable
         # :omniauthable, :omniauth_providers => [:github]

  has_many :authentication_tokens

end
