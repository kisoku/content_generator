require 'spec_helper'

class BaseClassHelper < Chef::Resource
  include Poise::Helpers::LWRPPolyfill
  include ContentGenerator

  attribute :squee, kind_of: String, generator: true
end

describe ContentGenerator do

  describe '#attribute' do
    it 'raises when passed an invalid generator name' do
      expect {
        Class.new(Chef::Resource) do
          include Poise::Helpers::LWRPPolyfill
          include ContentGenerator

          attribute :blam, generator: 'gronk'
        end
      }.to raise_error ArgumentError
    end
  end

  describe '#content_generators' do
    resource('subclass_test', parent: BaseClassHelper) do
      attribute :tacos, kind_of: String, generator: true
    end

    it 'should inherit generator maps from a parent class' do
      r = Chef::Resource::SubclassTest.new("gir", nil)
      expect(r.class.content_generators[:default]).to include :squee
      expect(r.class.content_generators[:default]).to include :tacos

    end
  end

  describe '#render' do
    describe 'default generator' do
      resource('default_test') do
        include Poise::Helpers::LWRPPolyfill
        include ContentGenerator

        attribute :herp, kind_of: String, generator: true, default: "bah"
      end

      it 'renders with the default generator' do
        r = Chef::Resource::DefaultTest.new("foo", nil)
        expect(r.render).to match /^herp = bah/
      end
    end

    describe 'named generator' do
      resource('named_test') do
        include Poise::Helpers::LWRPPolyfill
        include ContentGenerator
        attribute :derp, kind_of: String, generator: :scrooge, default: "humbug"
      end

      it 'renders with a named generator' do
        r = Chef::Resource::NamedTest.new("bar", nil)
        expect(r.render(:scrooge)).to match /^derp = humbug/
      end
    end

    describe 'default formatters' do
      resource 'default_formatter_test' do
        include Poise::Helpers::LWRPPolyfill
        include ContentGenerator

        attribute :foo, kind_of: String, default: "abc", generator: true

        def key_formatter(val)
          val.upcase
        end

        def value_formatter(val)
          val.upcase
        end
      end

      it 'formats keys and values with a default formatter' do
        r = Chef::Resource::DefaultFormatterTest.new('quux', nil)
        expect(r.render).to match /FOO = ABC/
      end
    end

    describe 'per attribute formatters' do
      resource 'attribute_formatter_test' do
        include Poise::Helpers::LWRPPolyfill
        include ContentGenerator

        attribute :baz, kind_of: String, default: "xyz", generator: true

        def key_formatter_baz(val)
          val.upcase
        end

        def value_formatter_baz(val)
          val.upcase
        end
      end

      it 'formats keys and values with a per attribute formatter' do
        r = Chef::Resource::AttributeFormatterTest.new('quux', nil)
        expect(r.render).to match /BAZ = XYZ/
      end
    end
  end
end
