# Application Serializer
module V1
  class ApplicationSerializer < ActiveModel::Serializer
    def attributes(*args)
      hash = super
      seed_data
      serialization_columns
      hash = hash.merge(load_attributes(load_serialization_config_for))
      hash = hash.merge(load_attributes(load_serialization_config_for('expand'))) if param_expand?
      hash = hash.merge(load_attributes(load_serialization_config_for('staff'))) if param_staff? || param_admin?
      hash = hash.merge(load_attributes(load_serialization_config_for('admin'))) if param_admin?
      hash
    end

    def load_serialization_config_for(type = 'attributes')
      @seed_data[@object.class.name.downcase.pluralize][type]
    end

    def serialization_columns
      @serialization_columns ||= @seed_data[@object.class.name.downcase.pluralize]['columns']
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

    def load_attributes(data)
      hash = {}
      data.each do |attribute|
        hash[@serialization_columns[attribute] || attribute] = @object[attribute] if @object.attributes.keys.include?(attribute)
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
end