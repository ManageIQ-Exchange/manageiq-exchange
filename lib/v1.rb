module V1
  VERSION_CONSTRAINT = /v\d+(\.[\da-zA-Z]+)*(\-[\da-zA-Z\-\.]+)?/
  VERSION_REGEX = /\A#{VERSION_CONSTRAINT}\z/

  ApiError = Class.new(StandardError)
  BadRequestError = Class.new(ApiError)
end