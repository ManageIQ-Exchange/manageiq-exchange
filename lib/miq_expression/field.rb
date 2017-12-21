class MiqExpression::Field
  REGEX = /
(?<model_name>([[:upper:]][[:alnum:]]*(::)?)+)
-
(?:
  (?<column>[a-z]+(_[[:alnum:]]+)*)
)
/x

  attr_reader :column
  attr_accessor :model

  def self.parse(field)
    parsed_params = parse_params(field) || return
    return unless parsed_params[:model_name]
    new(parsed_params[:model_name], parsed_params[:associations], parsed_params[:column])
  end

  def self.is_field?(field)
    return false unless field.kind_of?(String)
    match = REGEX.match(field)
    return false unless match
    model = match[:model_name].safe_constantize
    return false unless model
    !!(model < ApplicationRecord)
  end

  def self.parse_params(field)
    match = self::REGEX.match(field) || return
    # convert matches to hash to format
    # {:model_name => 'User', :associations => ...}
    parsed_params = Hash[match.names.map(&:to_sym).zip(match.to_a[1..-1])]
    parsed_params[:model_name] = parsed_params[:model_name].classify.safe_constantize
    parsed_params[:associations] = parsed_params[:associations].to_s.split(".")
    parsed_params
  end

  def initialize(model, associations, column)
    @model = model
    @associations = associations
    @column = column
  end

  def valid?
    model.column_names.include?(column)
  end
end