class User < ApplicationRecord

  include Gravtastic

  GRAVATAR_OPTIONS = { default: 'identicon', size: 256, rating: 'PG' }

  devise :masqueradable, :database_authenticatable, :registerable, :recoverable, :rememberable, :confirmable, :invitable, :lockable, :validatable, :omniauthable

  has_many :services, dependent: :destroy
  has_one_attached :image, dependent: :destroy

  gravtastic :email

  def avatar
    return self.image if self.image.attached?

    self.avatar_url || gravatar_url(GRAVATAR_OPTIONS)
  end

end
