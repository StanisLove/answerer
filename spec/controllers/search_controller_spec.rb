require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe "GET #index" do
    it 'searches in all documents' do
      expect(ThinkingSphinx).to receive(:search).with('123')
      get :index, model: 'Anywhere', query: '123'
    end

    it 'searches in model documents' do
      expect(Question).to receive(:search).with('123')
      get :index, model: 'Questions', query: '123'
    end
  end
end
