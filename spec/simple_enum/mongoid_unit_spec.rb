require 'spec_helper'
require 'simple_enum/mongoid'

describe SimpleEnum::Mongoid do
  def build_mongoid_class(&block)
    Class.new do
      include Mongoid::Document
      include SimpleEnum::Mongoid

      store_in collection: 'dummies'
      instance_eval(&block)
    end
  end

  context '.included' do
    subject { build_mongoid_class { as_enum :gender, %w{male female} } }

    it 'extends with SimpleEnum::Attribute' do
      expect(subject.singleton_class.ancestors).to include(SimpleEnum::Attribute)
    end

    it 'extends with SimpleEnum::Translation' do
      expect(subject.singleton_class.ancestors).to include(SimpleEnum::Translation)
    end
  end

  context '.as_enum' do
    it 'creates the field by default' do
      klass = build_mongoid_class { as_enum :gender, %w{male female} }
      expect(klass.fields['gender_cd']).to_not be_nil
    end

    it 'creates the field with custom type' do
      klass = build_mongoid_class { as_enum :gender, %w{male female}, field: { type: Integer } }
      expect(klass.fields['gender_cd'].type).to eq Integer
    end

    it 'skips field creation when field: false' do
      klass = build_mongoid_class { as_enum :gender, %w{male female}, field: false }
      expect(klass.fields['gender_cd']).to be_nil
    end

    it 'uses SimpleEnum.field as default field options' do
      original = SimpleEnum.field
      SimpleEnum.field = { type: Integer }

      klass = build_mongoid_class { as_enum :gender, %w{male female} }
      expect(klass.fields['gender_cd'].type).to eq Integer
    ensure
      SimpleEnum.field = original
    end

    it 'skips field creation when SimpleEnum.field is nil' do
      original = SimpleEnum.field
      SimpleEnum.field = nil

      klass = build_mongoid_class { as_enum :gender, %w{male female} }
      expect(klass.fields['gender_cd']).to be_nil
    ensure
      SimpleEnum.field = original
    end

    it 'returns a SimpleEnum::Enum' do
      klass = build_mongoid_class { as_enum :gender, %w{male female} }
      expect(klass.genders).to be_a(SimpleEnum::Enum)
    end
  end
end
