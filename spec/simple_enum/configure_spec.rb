require 'spec_helper'

describe SimpleEnum, '.configure' do
  it 'yields self to the block' do
    SimpleEnum.configure do |config|
      expect(config).to eq SimpleEnum
    end
  end

  it 'allows setting configuration values' do
    original_suffix = SimpleEnum.suffix

    SimpleEnum.configure do |config|
      config.suffix = '_test'
    end

    expect(SimpleEnum.suffix).to eq '_test'
  ensure
    SimpleEnum.suffix = original_suffix
  end
end
