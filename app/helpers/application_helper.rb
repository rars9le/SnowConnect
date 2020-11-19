module ApplicationHelper
  WEBSITE_NAME = 'SnowConnect'.freeze

  # CheckBoxのアイテムを定義
  SNOWSTYLE = %w(スキーヤー スノーボーダー).freeze
  PLAYSTYLE = %w(フリーラン ワンメイク ジブ バックカントリー ハーフパイプ パウダー アルペン).freeze

  def full_title(page_title = '')
    base_title = WEBSITE_NAME
    if page_title.empty?
      base_title
    else
      page_title + ' | ' + base_title
    end
  end

  def header_link_item(name, path)
    class_name = 'nav-item'
    class_name << ' active' if current_page?(path)

    content_tag :li, class: class_name do
      link_to name, path, class: 'nav-link'
    end
  end

  def active_action?(action_name)
    return "active" if action_name == params[:action]
  end

  def active?(controller_name, action_name)
    return "active" if controller_name == params[:controller] && action_name == params[:action]
  end

  def nav_link_add_active(name, path)
    class_name = 'nav-link nav-item'
    class_name << ' active' if current_page?(path)

    link_to name, path, class: class_name
  end

  def bootstrap_class_for(flash_type)
    case flash_type
    when 'success'
      'success'
    when 'error'
      'danger'
    when 'alert'
      'danger'
    when 'notice'
      'success'
    when 'danger'
      'danger'
    else
      flash_type.to_s
    end
  end
end
