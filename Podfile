platform :ios, '11.0'
inhibit_all_warnings!

def rxswift_pods
  pod 'RxSwift', '~> 5.0.0'
  pod 'RxSwiftExt', '~> 5.0.0'
end

def rxswift_test_pods
  pod 'RxBlocking', '~> 5.0.0'
end

def realm_pods
  pod 'RealmSwift', '~> 3.17.1'
  pod 'RxRealm', '~> 1.0.0'
end

def rswift_pods
  pod 'R.swift', '~> 5.0.3'
  pod 'R.swift.Library', '~> 5.0.0'
end

def quick_nimble_pods
  pod 'Quick', '~> 2.1.0'
  pod 'Nimble', '~> 7.3.4'
  pod 'RxNimble', '~> 4.5.0'
end

target 'Down' do
  use_frameworks!

  rxswift_pods
  pod 'RxCocoa', '~> 5.0.0'

  rswift_pods

  pod 'Fabric', '~> 1.10.2'
  pod 'Crashlytics', '~> 3.13.4'

  pod 'CircleProgressView', '~> 1.2.0'
  pod 'RxDataSources', '~> 4.0.1'
  pod 'SkyFloatingLabelTextField', '~> 3.7.0'
  pod 'Kingfisher', '~> 5.7.0'
  pod 'Parchment', '~> 1.6.0'
  pod 'NVActivityIndicatorView', '~> 4.7.0'
  pod 'XLActionController/Youtube', '~> 5.0.0'

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

  pod 'Alamofire', '~> 4.8.2'
  pod 'SwiftyJSON', '~> 5.0.0'
  pod 'SwiftHash', '~> 2.0.2'

  target 'DownKitTests' do
    inherit! :search_paths
    
    quick_nimble_pods
    rxswift_test_pods
  end
end
