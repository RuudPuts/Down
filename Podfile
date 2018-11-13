platform :ios, '11.0'
inhibit_all_warnings!

def rxswift_pods
  pod 'RxSwift', '~> 4.3.0'
  pod 'RxCocoa', '~> 4.3.0'
  pod 'RxSwiftExt', '3.3.0'
end

def rxswift_test_pods
  pod 'RxBlocking', '~> 4.3.0'
end

def realm_pods
  pod 'RealmSwift', '~> 3.11.0'
  pod 'RxRealm', '~> 0.7.0'
end

def rswift_pods
  pod 'R.swift', '~> 4.0.0'
  pod 'R.swift.Library', '~> 4.0.0'
end

def quick_nimble_pods
  pod 'Quick', '~> 1.3.0'
  pod 'Nimble', '~> 7.3.0'
  pod 'RxNimble', '~> 4.4.0'
end

target 'Down' do
  use_frameworks!

  rxswift_pods
  rswift_pods
  pod 'RxDataSources', '~> 3.1.0'

  pod 'Fabric', '~> 1.8.0'
  pod 'Crashlytics', '~> 3.11.0'

  pod 'SkyFloatingLabelTextField', '~> 3.6.0'
  pod 'CircleProgressView', '~> 1.1.0'
  pod 'Kingfisher', '4.9.0'

  target 'DownTests' do
    inherit! :search_paths
    
    quick_nimble_pods
    rxswift_test_pods
  end
end

target 'DownKit' do
  use_frameworks!

  rxswift_pods
  realm_pods  
  pod 'Alamofire', '~> 4.7.0'
  pod 'SwiftyJSON', '~> 4.2.0'
  pod 'SwiftHash', '~> 2.0.0'

  target 'DownKitTests' do
    inherit! :search_paths
    
    quick_nimble_pods
    rxswift_test_pods
  end
end
