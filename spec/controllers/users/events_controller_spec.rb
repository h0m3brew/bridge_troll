# frozen_string_literal: true

require 'rails_helper'

describe Users::EventsController do
  let(:user) { FactoryBot.create(:user) }
  let(:event) { FactoryBot.create(:event) }

  before { FactoryBot.create(:rsvp, user: user, event: event, checked_in: true) }

  describe '#index' do
    it 'responds successfully with json' do
      get :index, params: { user_id: user.id }
      expect(response.media_type).to eq('application/json')
      expect(response).to be_successful
    end

    it 'responds with the correct count' do
      get :index, params: { user_id: user.id }
      expected_response = { event_count: 1 }.to_json
      expect(response.body).to eq(expected_response)
    end
  end
end
