require 'spec_helper'

describe '#lpush(key, value)' do
  before { @key = 'mock-redis-test:57367' }

  it 'returns the new size of the list' do
    @redises.lpush(@key, 'X').should == 1
    @redises.lpush(@key, 'X').should == 2
  end

  it 'creates a new list when run against a nonexistent key' do
    @redises.lpush(@key, 'value')
    @redises.llen(@key).should == 1
  end

  it 'prepends items to the list' do
    @redises.lpush(@key, 'bert')
    @redises.lpush(@key, 'ernie')

    @redises.lindex(@key, 0).should == 'ernie'
    @redises.lindex(@key, 1).should == 'bert'
  end

  it 'stores values as strings' do
    @redises.lpush(@key, 1)
    @redises.lindex(@key, 0).should == '1'
  end

  it 'supports a variable number of arguments' do
    @redises.lpush(@key, [1, 2, 3]).should == 3
    @redises.lindex(@key, 0).should == '3'
    @redises.lindex(@key, 1).should == '2'
    @redises.lindex(@key, 2).should == '1'
  end

  context 'allow indifferent keytype access' do
    it 'returns the correct results for integer keys' do
      @key = 1234
      @redises.del(@key)
      @redises.lpush(@key, 'abcd')
      @redises.lrange(@key, 0, -1).should == ['abcd']
      @redises.lrange(@key.to_s, 0, -1).should == ['abcd']
    end

    it 'returns the correct results for string keys' do
      @key = '1234'
      @redises.del(@key)
      @redises.lpush(@key, 'abcd')
      @redises.lrange(@key, 0, -1).should == ['abcd']
    end
  end

  it 'raises an error if an empty array is given' do
    lambda do
      @redises.lpush(@key, [])
    end.should raise_error(Redis::CommandError)
  end

  it_should_behave_like 'a list-only command'
end
