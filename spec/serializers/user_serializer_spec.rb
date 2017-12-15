require 'rails_helper'

RSpec.describe UserSerializer, type: :serializer do
  let(:object_columns) { json_obj_columns }

  let(:tests) do
    {

      "Serialize a user with normal request": {
        params: {},
        types:  %w[attributes]
      },
      "Serialize for staff": {
        params: { staff: true },
        types:  %w[attributes staff]
      },
      "Serialize for admin": {
        params: { admin: true },
        types:  %w[attributes staff admin]
      }
    }
  end
  describe 'Running tests' do
    it 'should have a name that matches' do
      tests.each_value do |configuration|
        object_serialized = generate_serializer(configuration[:params])
        objects = generate_objects(*configuration[:types])
        objects.each do |attr|
          expect(object_serialized[object_columns[attr] || attr]).to eql(parse_if_time(@obj.send(attr)))
        end
        # With expand of resources
        object_serialized = generate_serializer(configuration[:params].merge!(expand: 'resources'))
        objects = generate_objects(*configuration[:types].push('expand'))
        objects.each do |attr|
          expect(object_serialized[object_columns[attr] || attr]).to eql(parse_if_time(@obj.send(attr)))
        end
      end
    end
  end
end
