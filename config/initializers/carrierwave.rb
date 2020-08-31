CarrierWave.configure do |config|  

  config.fog_credentials = {  
    provider: 'AWS',  
    aws_access_key_id: 'AKIAXPRAGA4ATL2TSH5G',  
    aws_secret_access_key: '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',  
    region: 'ap-northeast-1' 
  }  

  config.fog_directory  = 'snowconnect-s3'  
  # config.asset_host = 'https://snowconnect-s3.s3.amazonaws.com'   
  # config.cache_storage = :fog  
  # config.fog_provider = 'fog/aws'  

end  