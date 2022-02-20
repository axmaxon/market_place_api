class User < ApplicationRecord
  validates :email, uniqueness: true
  validates_format_of :email, with: /@/
  validates :password_digest, presence: true

  # Шифрует пароли путем хеширования - генерирует 'password_digest'
  # из атрибута 'password', указанного при создании юзера
  has_secure_password
end
