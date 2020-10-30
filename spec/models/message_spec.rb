# == Schema Information
#
# Table name: messages
#
#  id         :bigint           not null, primary key
#  message    :text(65535)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  room_id    :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_messages_on_room_id  (room_id)
#  index_messages_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (room_id => rooms.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Message, type: :model do
  let(:message) { create(:message) }

  it '有効なファクトリを持つこと' do
    expect(message).to be_valid
  end

  it 'メッセージ、ルーム、ユーザーが有効であること' do
    user = create(:user)
    room = create(:room)
    message = Message.new(
      message: 'test',
      user: user,
      room: room
    )
    expect(message).to be_valid
  end

  describe '存在性の検証' do
    it '内容がない場合、無効であること' do
      message.content = ''
      message.valid?
      expect(message).to_not be_valid
    end
    it 'ユーザーがない場合、無効であること' do
      message.user = nil
      message.valid?
      expect(message).to_not be_valid
    end
    it 'ルームがない場合、無効であること' do
      message.room = nil
      message.valid?
      expect(message).to_not be_valid
    end
  end

  describe '文字数の検証' do
    it 'メッセージが255文字以内の場合、有効であること' do
      message.content = 'a' * 255
      expect(message).to be_valid
    end
    it 'メッセージが256文字以上の場合、無効であること' do
      message.content = 'a' * 256
      expect(message).to_not be_valid
    end
  end
end
