module ApplicationHelper
  WEBSITE_NAME = 'SnowConnect'.freeze

  # CheckBoxのアイテムを定義
  SNOWSTYLE = %w[スキーヤー スノーボーダー].freeze
  PLAYSTYLE = %w[フリーラン ワンメイク ジブ ハーフパイプ パウダー バックカントリー アルペン].freeze

  def full_title(page_title = '')
    base_title = WEBSITE_NAME
    if page_title.empty?
      base_title
    else
      page_title + ' | ' + base_title
    end
  end

end
