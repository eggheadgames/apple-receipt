Pod::Spec.new do |s|
  s.name             = 'ReceiptKit'
  s.version          = '1.0.0'
  s.summary          = 'Swift receipt framework to retrieve iOS app purchase date'
  s.homepage         = 'https://github.com/eggheadgames/ReceiptKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = 'Egghead Games LLC'
  s.source           = { :git => 'https://github.com/eggheadgames/ReceiptKit.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'ReceiptKit/Classes/**/*'
end
