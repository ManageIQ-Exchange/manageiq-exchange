##
# User
# Stores information about the user. It is created automatically when authenticated
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :trackable, :token_authenticatable, :timeoutable # For Tiddle usage
  #  :registerable,  :recoverable, :rememberable, :validatable
  # :omniauthable, :omniauth_providers => [:github]

  has_many :authentication_tokens, dependent: :destroy

  def self.first_or_create(github_user)
    return nil if github_user.id.nil?
    User.where(id: github_user.id).first_or_create do |user|
      user.name = github_user.name # assuming the user model has a name
      user.github_avatar_url = github_user.avatar_url
      user.github_html_url = github_user.html_url
      user.github_id = github_user.id
      user.github_login = github_user.login
      user.github_company = github_user.company
      user.github_type = github_user.type
      user.github_blog = github_user.blog
      user.github_location = github_user.location
      user.email = github_user.email
      user.github_bio = github_user.bio
      user.github_created_at = github_user.created_at
      user.github_updated_at = github_user.updated_at
    end
    # TODO: It is possible that first_or_create with a block does not update the user
    # Verify and change to first_or_initialize + update
  end
end
