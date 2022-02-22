# Кодирует и декодирует полезную нагрузку (payload) для токена аутентификации
# (имеющего JWT стандарт), при кодировании добавляет время истечения срока действия
class JsonWebToken
  SECRET_KEY = Rails.application.secrets.secret_key_base.to_s

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY).first

    # Позволяет использовать для доступа к значениям хэша ключи и в строковом и в
    # символьном виде
    HashWithIndifferentAccess.new(decoded)
  end
end
