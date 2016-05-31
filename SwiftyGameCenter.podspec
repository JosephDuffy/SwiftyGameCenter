Pod::Spec.new do |s|
  s.name         = "SwiftyGameCenter"
  s.version      = "0.0.1"
  s.summary      = "A Swift wrapper for Game Center."
  s.homepage     = "https://github.com/JosephDuffy/SwiftyGameCenter"
  s.license      = "MIT"
  s.author       = "Joseph Duffy"
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"
  s.tvos.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/JosephDuffy/SwiftyGameCenter.git", :tag => "0.0.1" }
  s.source_files = "SwiftyGameCenter/*.swift"
  s.framework    = "GameKit"
end
