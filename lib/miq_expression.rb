class MiqExpression
  attr_accessor :exp, :context_type, :preprocess_options

  def initialize(exp, ctype = nil)
    @exp = exp
    @context_type = ctype
  end

  def valid?(component = exp)
    operator = component.keys.first
    case operator.downcase
      when "and", "or"
        component[operator].all?(&method(:valid?))
      when "not", "!"
        valid?(component[operator])
      when "find"
        validate_set = Set.new(%w(checkall checkany checkcount search))
        validate_keys = component[operator].keys.select { |k| validate_set.include?(k) }
        validate_keys.all? { |k| valid?(component[operator][k]) }
      else
        if component[operator].key?("field")
          field = Field.parse(component[operator]["field"])
          return false if field && !field.valid?
        end
        if Field.is_field?(component[operator]["value"])
          field = Field.parse(component[operator]["value"])
          return false unless field && field.valid?
        end
        true
    end
  end

  def to_sql(tz = nil)
    tz ||= "UTC"
    @pexp, attrs = preprocess_for_sql(@exp)
    sql = to_arel(@pexp, tz).to_sql if @pexp.present?
    incl = includes_for_sql unless sql.blank?
    [sql, incl, attrs]
  end

  def preprocess_for_sql(exp, attrs = nil)
    attrs ||= {:supported_by_sql => true}
    exp.empty? ? [nil, attrs] : [exp, attrs]
  end

  def includes_for_sql
    col_details.values.each_with_object({}) { |v, result| result.deep_merge!(v[:include]) }
  end

  def col_details
    @col_details ||= self.class.get_cols_from_expression(@exp, @preprocess_options)
  end

  def self.get_cols_from_expression(exp, options = {})
    result = {}
    if exp.kind_of?(Hash)
        exp.each_value { |v| result.merge!(get_cols_from_expression(v, options)) }
    elsif exp.kind_of?(Array)
      exp.each { |v| result.merge!(get_cols_from_expression(v, options)) }
    end
    result
  end

  def self.get_col_info(field, options = {})
    result ||= {:data_type => nil, :virtual_reflection => false, :virtual_column => false, :sql_support => true, :excluded_by_preprocess_options => false, :tag => false, :include => {}}
    col = field.split("-").last if field.include?("-")
    parts = field.split("-").first.split(".")
    model = parts.shift
    result
  end


  def to_arel(exp, tz)
    operator = exp.keys.first
    field = Field.parse(exp[operator]["field"]) if exp[operator].kind_of?(Hash) && exp[operator]["field"]
    arel_attribute = field && field.model.arel_attribute(field.column)
    if exp[operator].kind_of?(Hash) && exp[operator]["value"] && Field.is_field?(exp[operator]["value"])
      field_value = Field.parse(exp[operator]["value"])
      parsed_value = field_value.target.arel_attribute(field_value.column)
    elsif exp[operator].kind_of?(Hash)
      parsed_value = exp[operator]["value"]
    end
    case operator.downcase
      when "equal", "="
        arel_attribute.eq(parsed_value)
      when ">"
        arel_attribute.gt(parsed_value)
      when "after"
        value = RelativeDatetime.normalize(parsed_value, tz, "end", field.date?)
        arel_attribute.gt(value)
      when ">="
        arel_attribute.gteq(parsed_value)
      when "<"
        arel_attribute.lt(parsed_value)
      when "before"
        value = RelativeDatetime.normalize(parsed_value, tz, "beginning", field.date?)
        arel_attribute.lt(value)
      when "<="
        arel_attribute.lteq(parsed_value)
      when "!="
        arel_attribute.not_eq(parsed_value)
      when "like", "includes"
        escape = nil
        case_sensitive = true
        arel_attribute.matches("%#{parsed_value}%", escape, case_sensitive)
      when "starts with"
        escape = nil
        case_sensitive = true
        arel_attribute.matches("#{parsed_value}%", escape, case_sensitive)
      when "ends with"
        escape = nil
        case_sensitive = true
        arel_attribute.matches("%#{parsed_value}", escape, case_sensitive)
      when "not like"
        escape = nil
        case_sensitive = true
        arel_attribute.does_not_match("%#{parsed_value}%", escape, case_sensitive)
      when "and"
        operands = exp[operator].each_with_object([]) do |operand, result|
          next if operand.blank?
          arel = to_arel(operand, tz)
          next if arel.blank?
          result << arel
        end
        Arel::Nodes::And.new(operands)
      when "or"
        operands = exp[operator].each_with_object([]) do |operand, result|
          next if operand.blank?
          arel = to_arel(operand, tz)
          next if arel.blank?
          result << arel
        end
        first, *rest = operands
        rest.inject(first) { |lhs, rhs| lhs.or(rhs) }
      when "not", "!"
        Arel::Nodes::Not.new(to_arel(exp[operator], tz))
      when "is null"
        arel_attribute.eq(nil)
      when "is not null"
        arel_attribute.not_eq(nil)
      when "is empty"
        arel = arel_attribute.eq(nil)
        arel = arel.or(arel_attribute.eq("")) if field.string?
        arel
      when "is not empty"
        arel = arel_attribute.not_eq(nil)
        arel = arel.and(arel_attribute.not_eq("")) if field.string?
        arel
      when "contains"
        # Only support for tags of the main model
        if exp[operator].key?("tag")
          tag = Tag.parse(exp[operator]["tag"])
          ids = tag.model.find_tagged_with(:any => parsed_value, :ns => tag.namespace).pluck(:id)
          tag.model.arel_attribute(:id).in(ids)
        else
          raise unless field.associations.one?
          reflection = field.reflections.first
          arel = arel_attribute.eq(parsed_value)
          arel = arel.and(Arel::Nodes::SqlLiteral.new(extract_where_values(reflection.klass, reflection.scope))) if reflection.scope
          field.model.arel_attribute(:id).in(
              field.target.arel_table.where(arel).project(field.target.arel_table[reflection.foreign_key]).distinct
          )
        end
      when "is"
        value = parsed_value
        start_val = RelativeDatetime.normalize(value, tz, "beginning", field.date?)
        end_val = RelativeDatetime.normalize(value, tz, "end", field.date?)

        if !field.date? || RelativeDatetime.relative?(value)
          arel_attribute.between(start_val..end_val)
        else
          arel_attribute.eq(start_val)
        end
      when "from"
        start_val, end_val = parsed_value
        start_val = RelativeDatetime.normalize(start_val, tz, "beginning", field.date?)
        end_val   = RelativeDatetime.normalize(end_val, tz, "end", field.date?)
        arel_attribute.between(start_val..end_val)
      else
        raise _("operator '%{operator_name}' is not supported") % {:operator_name => operator}
    end
  end
end