##
# User
# Stores information about the user. It is created automatically when authenticated
# Copied from Github data
#
# User(id: integer,
#      name: string,
#      admin: boolean,
#      staff: boolean,
#      karma: integer,
#      github_avatar_url: string,
#      github_html_url: string,
#      github_id: string,
#      github_login: string,
#      github_company: string,
#      github_type: string,
#      github_blog: string,
#      github_location: string,
#      github_bio: string,
#      github_created_at: datetime,
#      github_updated_at: datetime,
#      email: string,
#      remember_created_at: datetime,
#      sign_in_count: integer, current_sign_in_at: datetime,
#      last_sign_in_at: datetime,
#      current_sign_in_ip: inet,
#      last_sign_in_ip: inet,
#      created_at: datetime,
#      updated_at: datetime)
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :trackable, :token_authenticatable, :timeoutable # For Tiddle usage
  #  :registerable,  :recoverable, :rememberable, :validatable
  # :omniauthable, :omniauth_providers => [:github]

  has_many :authentication_tokens, dependent: :destroy
  has_many :spins, dependent: :destroy

  validates :name,              presence: true
  validates :admin,             inclusion: { in: [true, false] }
  validates :staff,             inclusion: { in: [true, false] }
  validates :karma,             presence: true
  validates :github_avatar_url, presence: true
  validates :github_html_url,   presence: true
  validates :github_id,         presence: true
  validates :github_login,      presence: true
  validates :github_company,    exclusion: { in: [nil]}
  validates :github_type,       presence: true
  validates :github_blog,       exclusion: { in: [nil]}
  validates :github_html_url,   presence: true
  validates :github_location,   presence: true
  validates :github_bio,        exclusion: { in: [nil]}
  validates :email,             presence: true
  validates :sign_in_count,     numericality: true

  def self.first_or_create(github_user)
    return nil if github_user.id.nil?
    User.where(id: github_user.id).first_or_create do |user|
      user.name              = github_user.name # assuming the user model has a name
      user.github_avatar_url = github_user.avatar_url || ''
      user.github_html_url   = github_user.html_url || ''
      user.github_id         = github_user.id
      user.github_login      = github_user.login
      user.github_company    = github_user.company || ''
      user.github_type       = github_user.type
      user.github_blog       = github_user.blog || ''
      user.github_location   = github_user.location || ''
      user.email             = github_user.email
      user.github_bio        = github_user.bio || ''
      user.github_created_at = github_user.created_at
      user.github_updated_at = github_user.updated_at
    end
    # TODO: It is possible that first_or_create with a block does not update the user
    # Verify and change to first_or_initialize + update
  end
end
