
Pod::Spec.new do |s|
  s.name         = "ESPictureBrowser"
  s.version      = "0.2"
  s.summary      = "A very simple to use picture browser.."
  s.homepage     = "https://github.com/EnjoySR/ESPictureBrowser"
  s.license = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author             = { "EnjoySR" => "yinqiaoyin@gmail.com" }
  s.social_media_url   = "http://weibo.com/EnjoySR"
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/EnjoySR/ESPictureBrowser.git", :tag => s.version }
  s.source_files  = "ESPictureBrowserDemo/ESPictureBrowserDemo/ESPictureBrowser/*.{h,m}"
  s.requires_arc = true
  s.dependency "PINRemoteImage", "~> 3.0.0-beta.3"

end
