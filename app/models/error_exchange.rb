class ErrorExchange

  attr_reader :identifier, :status

  def initialize(identifier, status, extra_info = nil)
    @identifier = identifier
    @status     = status
    @extra_info = extra_info
  end

  def as_json(*)
    hash = {
        status: Rack::Utils.status_code(status),
        code: identifier,
        title: translated_payload[:title],
        detail: translated_payload[:detail],
    }
    hash[:extra_info] = @extra_info if @extra_info
    hash
  end

  def translated_payload
    I18n.translate("errors.#{identifier}")
  end
end