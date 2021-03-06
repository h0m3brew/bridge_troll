# frozen_string_literal: true

require 'rails_helper'

describe AccountMerger do
  before do
    allow_any_instance_of(described_class).to receive(:gets).and_return('y')
  end

  describe 'merging two users' do
    before do
      @user_to_keep = create(:rsvp).user
      @user_to_merge = create(:rsvp).user
      @other_user = create(:rsvp).user

      event_both_attended = create(:event)
      create(:rsvp, user: @user_to_keep, event: event_both_attended)
      create(:rsvp, user: @user_to_merge, event: event_both_attended)
    end

    it 'merges all the RSVPs from one account onto another' do
      merger = described_class.new(@user_to_keep, @user_to_merge)
      expect do
        merger.merge!
      end.to change(User, :count).by(-1)

      expect(@user_to_keep.reload.rsvps.length).to eq(3)
      expect do
        User.find(@user_to_merge.id)
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  it 'refuses to merge the same account onto itself' do
    user = create(:user)

    expect do
      expect do
        described_class.new(user, user).merge!
      end.not_to change(User, :count)
    end.to raise_error(RuntimeError)
  end
end
