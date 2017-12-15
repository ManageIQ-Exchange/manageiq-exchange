# Application Serializer
class ApplicationSerializer < ActiveModel::Serializer
  def attributes(*_args)
    loader_data
  end

  def load_serialization_config_for(type = 'attributes')
    seed_data[@object.class.name.downcase.pluralize][type]
  end

  def param_admin?
    @instance_options[:admin]
  end

  def param_staff?
    @instance_options[:staff]
  end

  def param_expand?
    @instance_options[:expand]
  end

  def loader_data
    hash = {}
    columns = load_serialization_config_for('columns')
    hash = load_attributes(hash, columns, load_serialization_config_for)
    hash = load_attributes(hash, columns, load_serialization_config_for('expand')) if param_expand?
    hash = load_attributes(hash, columns, load_serialization_config_for('staff')) if param_staff? || param_admin?
    hash = load_attributes(hash, columns, load_serialization_config_for('admin')) if param_admin?
    hash
  end

  def load_attributes(hash, columns, data)
    data.each do |attribute|
      hash[columns[attribute] || attribute] = @object[attribute]
    end
    hash
  end

  def seed_file_name
    @seed_file_name ||= Rails.root.join('product', 'json_returns.yml')
  end

  def seed_data
    @seed_data ||= File.exist?(seed_file_name) ? YAML.load_file(seed_file_name) : []
  end
end
