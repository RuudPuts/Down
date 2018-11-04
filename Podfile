platform :ios, '11.0'
inhibit_all_warnings!

def rxswift_pods
  pod 'RxSwift', '~> 4.3'
  pod 'RxCocoa', '~> 4.3'
  pod 'RxSwiftExt', '3.3'
end

def rxswift_test_pods
  pod 'RxBlocking', '~> 4.3'
end

def rswift_pods
  pod 'R.swift', '~> 4.0'
  pod 'R.swift.Library', '~> 4.0'
end

target 'Down' do
  use_frameworks!

  rxswift_pods
  rswift_pods
  pod 'RxDataSources', '~> 3.1'

  pod 'SkyFloatingLabelTextField', '~> 3.6'
  pod 'CircleProgressView', '~> 1.1'
  pod 'Kingfisher', '4.9' 

  target 'DownTests' do
    inherit! :search_paths
    
    rxswift_test_pods
  end
end

target 'DownKit' do
  use_frameworks!

  rxswift_pods
  pod 'Alamofire', '~> 4.7'
  pod 'SwiftyJSON', '~> 4.2'
  pod 'RealmSwift', '~> 3.11'
  pod 'SwiftHash', '~> 2.0'

  target 'DownKitTests' do
    inherit! :search_paths
    
    rxswift_test_pods
  end
end
