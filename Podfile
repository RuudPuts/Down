platform :ios, '11.0'
inhibit_all_warnings!

def rxswift_pods
  pod 'RxSwift', '~> 4.4.0'
  pod 'RxSwiftExt', '~> 3.4.0'
end

def rxswift_test_pods
  pod 'RxBlocking', '~> 4.4.0'
end

def realm_pods
  pod 'RealmSwift', '~> 3.13.0'
  pod 'RxRealm', '~> 0.7.0'
end

def result_pods
  pod 'Result', '~> 4.0.0'
  pod 'RxResult', :git => 'https://github.com/RuudPuts/RxResult.git', :branch => 'swift4'
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
  pod 'RxCocoa', '~> 4.4.0'
  
  result_pods
  rswift_pods

  pod 'Fabric', '~> 1.9.0'
  pod 'Crashlytics', '~> 3.12.0'

  pod 'RxDataSources', '~> 3.1.0'
  pod 'SkyFloatingLabelTextField', '~> 3.6.0'
  pod 'CircleProgressView', '~> 1.2.0'
  pod 'Kingfisher', '~> 4.10.0'
  pod 'Parchment', '~> 1.5.0'

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

post_install do |installer|

    # Targets to override the swift version to 4.0
    # (which don't support swift 4.2 yet, but don't specifically set their swift version to 4.0 in the podspec)
    swift4_override_targets = ['R.swift.Library']

    installer.pods_project.targets.each do |target|
        if swift4_override_targets.include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.0'
            end
        end
    end
end
