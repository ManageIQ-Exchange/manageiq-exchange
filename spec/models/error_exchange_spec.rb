require 'rails_helper'

RSpec.describe ErrorExchange, type: :model do
  subject { ErrorExchange.new(:spin_not_found, :not_found, { try: 3 }) }
  it 'Generate a ErrorExchange Model' do
    expect(subject).to be_kind_of ErrorExchange
  end

  it 'Returns the correct translation' do
    expect(subject.translated_payload).to eq I18n.translate('errors.spin_not_found')
  end

  it 'Returns a json' do
    hash = {
      status: Rack::Utils.status_code(:not_found),
      code: :spin_not_found,
      title: I18n.translate('errors.spin_not_found')[:title],
      detail: I18n.translate('errors.spin_not_found')[:detail],
      extra_info: { try: 3 }
    }
    expect(subject.as_json).to eq hash
  end
end
