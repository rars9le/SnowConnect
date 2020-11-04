require 'rails_helper'

RSpec.describe 'Messages', type: :request do
  let!(:message) { 
    user = create(:user)
    room = create(:room)
    message = Message.new(message: 'test', user: user,room: room) }

  describe '#create' do
    context 'パラメータが揃っている場合' do
      it '正常に登録できること' do
        user = create(:user)
        room = create(:room)
        message = Message.new(message: 'test', user: user, room: room)
        expect { message.save }.to change { user.messages.count }.by(1)
      end
    end

    context 'パラメータが揃っていない場合' do
      it '登録できないこと' do
        user = create(:user)
        room = create(:room)
        message = Message.new(message: '', user: user, room: room)
        expect { message.save }.to change { user.messages.count }.by(0)
      end
    end
  end

  describe '#destroy' do
    it '正常に削除できること' do
      user = create(:user)
      room = create(:room)
      message = Message.new(message: 'test', user: user, room: room)
      message.save!
      expect { message.destroy }.to change { user.messages.count }.by(-1)
    end
  end
end
