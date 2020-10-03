module RoomsHelper
  
  # 相手アバターを取得して表示するメソッド
  def opponent_userAvator(room)
    # 中間テーブルから相手ユーザーのデータを取得
    entry = room.entries.where.not(user_id: current_user)
    # 相手ユーザーの名前を取得
    avator = entry[0].user.avator
    # アバターを表示
    if avator.present?
      tag.img src:avator.to_s, class: "feed-circle"
    else
      tag.img src:'/assets/default.png', class: "feed-circle" 
    end
  end

  # 相手ユーザー名を取得して表示するメソッド
  def opponent_userName(room)
    # 中間テーブルから相手ユーザーのデータを取得
    entry = room.entries.where.not(user_id: current_user)
    # 相手ユーザーの名前を取得
    name = entry[0].user.name
    # 名前を表示
    "#{name}"
  end

  # 最新メッセージのデータを取得して表示するメソッド
  def most_new_message_preview(room)
    # 最新メッセージのデータを取得する
    message = room.messages.order(updated_at: :desc).limit(1)
    # 配列から取り出す
    message = message[0]
    # メッセージの有無を判定
    if message.present?
      # メッセージがあれば内容を表示
      tag.p "#{message.message}"
    else
      # メッセージがなければ[ まだメッセージはありません ]を表示
      tag.p "[ まだメッセージはありません ]"
    end
  end

    # 最新メッセージのデータを取得して表示するメソッド
    def most_new_message_date_preview(room)
      # 最新メッセージのデータを取得する
      message = room.messages.order(updated_at: :desc).limit(1)
      # 配列から取り出す
      message = message[0]
      # メッセージの有無を判定
      if message.present?
        # メッセージがあれば内容を表示
        tag.span "#{message.updated_at.to_s(:datetime_jp)}"
      end
    end

end
