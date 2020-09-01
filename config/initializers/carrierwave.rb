CarrierWave.configure do |config|  
  config.fog_provider = 'fog/aws'
  config.fog_credentials = {
    provider:              'AWS',
    # アクセスキー
    aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
    # シークレットキー
    aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    # Tokyo
    region:                'ap-northeast-1',
  }

  # 公開・非公開の切り替え
  config.fog_public     = false

  # キャッシュの保存期間
  config.fog_attributes = { 'Cache-Control' => "max-age=#{365.day.to_i}" }

  # キャッシュをS3に保存
  config.cache_storage = :fog

  # 環境ごとにS3のバケットを指定
  case Rails.env
    when 'production'
      config.fog_directory = 'snow-connect-s3'
      config.asset_host = 'https://snow-connect-s3.s3-ap-northeast-1.amazonaws.com'

    when 'development'
      config.fog_directory = 'dev-snow-connect-s3'
      config.asset_host = 'https://dev-snow-connect-s3.s3-ap-northeast-1.amazonaws.com'

    when 'test'
      config.fog_directory = 'dev-snow-connect-s3'
      config.asset_host = 'https://dev-snow-connect-s3.s3-ap-northeast-1.amazonaws.com'
  end
end