require 'spec_helper'

describe OMDB::Default do
  describe 'Hash#method_missing' do
    let(:hash) { { a: 'a', b: 'b', c: 'c' } }

    it 'should allow value access through dot notation' do
      expect(hash.a).to eq('a')
    end
  end

  describe 'String#to_snake_case' do
    it 'should convert strings to snake case' do
      expect('CamelCasedString'.to_snake_case).to eq('camel_cased_string')
    end
  end
end
