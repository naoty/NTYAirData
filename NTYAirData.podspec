Pod::Spec.new do |s|
  s.name             = "NTYAirData"
  s.version          = "0.1.0"
  s.summary          = "A RESTful API server for Core Data"
  s.description      = <<-DESC
                       This is a RESTful API server which is embedded in your
                       application and responses data from Core Data.
                       This server helps to manage data in development.
                       DESC
  s.homepage         = "https://github.com/naoty/NTYAirData"
  s.license          = "MIT"
  s.author           = { "Naoto Kaneko" => "naoty.k@gmail.com" }
  s.source           = { :git => "https://github.com/naoty/NTYAirData.git", :tag => s.version.to_s }
  s.social_media_url = "https://twitter.com/naoty_k"
  s.source_files     = "Classes"
  s.framework        = "CoreData"
  s.requires_arc     = true

  s.dependency "GCDWebServer", "~> 2.4.0"
  s.dependency "ActiveSupportInflector", "~> 0.0.1"
end
