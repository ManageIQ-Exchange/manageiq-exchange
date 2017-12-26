module Serializers
  module SerializeHelpers
    def to_iso(value)
      value.iso8601(3)
    end

    def parse_if_time(value)
      value.class.name == 'Time' ? to_iso(value) : value
    end

    def json_returns_file
      @json_returns ||= YAML.load_file(Rails.root.join('product', 'json_returns.yml'))
    end

    def json_obj
      @json_obj ||= json_returns_file[described_class.to_s.demodulize.gsub('Serializer', '').downcase.pluralize]
    end

    def json_obj_columns
      json_obj['columns']
    end

    def generate_serializer(options = {})
      @obj = FactoryBot.build(described_class.to_s.demodulize.gsub('Serializer', '').downcase.to_sym)
      # Create a serializer instance
      serializer = described_class.new(@obj, @instance_options = options)
      # Create a serialization based on the configured adapter
      serialization = ActiveModelSerializers::Adapter.create(serializer)
      JSON.parse(serialization.to_json)
    end

    def generate_objects(*args)
      hash = []
      data = json_obj
      args.each do |type|
        hash += data[type]
      end
      hash
    end
  end
end
