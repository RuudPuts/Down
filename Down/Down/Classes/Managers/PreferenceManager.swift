//
//  PreferenceManager.swift
//  Down
//
//  Created by Ruud Puts on 24/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import Foundation

class PreferenceManager {
    
    struct PreferenceKeys {
        static let sabNZBdBaseUrl = "SabNZBdBaseUrl"
        static let sabNZBdApiKey = "SabNZBdBaseApiKey"
    }
    
    class var sabNZBdBaseUrl: String {
        get {
            return getPreference(PreferenceKeys.sabNZBdBaseUrl) as! String!
        }
        set {
            setPreference(object:newValue, forKey:PreferenceKeys.sabNZBdBaseUrl)
        }
    }
    
    class var sabNZBdApiKey: String {
        get {
            return getPreference(PreferenceKeys.sabNZBdApiKey) as! String!
        }
        set {
            setPreference(object:newValue, forKey:PreferenceKeys.sabNZBdBaseUrl)
        }
    }
    
    //MARK: - Private functions
    
    private class func getPreference(preferenceKey: String) -> AnyObject? {
        return NSUserDefaults.standardUserDefaults().objectForKey(preferenceKey)
    }
    
    private class func setPreference(#object: String, forKey key:String) {
        NSUserDefaults.standardUserDefaults().setObject(object, forKey: key)
    }
}