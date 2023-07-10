require 'rails_helper'

RSpec.describe Search do
  it 'calls for all scopes' do
    obj = Search.new('query', 'all')
    allow(ThinkingSphinx).to receive(:search).with('query', classes: [Question, Answer, Comment, User], page: 1)
    obj.call
  end

  it 'calls for question scope' do
    obj = Search.new('query', 'question')
    allow(Question).to receive(:search).with('query', page: 1)
    obj.call
  end

  it 'calls for answer scope' do
    obj = Search.new('query', 'answer')
    allow(Answer).to receive(:search).with('query', page: 1)
    obj.call
  end

  it 'calls for comment scope' do
    obj = Search.new('query', 'comment')
    allow(Comment).to receive(:search).with('query', page: 1)
    obj.call
  end

  it 'calls for user scope' do
    obj = Search.new('query', 'user')
    allow(User).to receive(:search).with('query', page: 1)
    obj.call
  end
end
