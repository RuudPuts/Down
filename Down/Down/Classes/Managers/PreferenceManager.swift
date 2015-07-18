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
        static let sabNZBdHost = "SabNZBdHost"
        static let sabNZBdApiKey = "SabNZBdApiKey"
        
        static let sickbeardHost = "SickbeardHost"
        static let sickbeardApiKey = "SickbeardApiKey"
        
        static let couchPotatoHost = "CouchPotatoHost"
        static let couchPotatoApiKey = "CouchPotatoApiKey"
    }
    
    class var sabNZBdHost: String {
        get {
            return cleanupHost(getPreference(PreferenceKeys.sabNZBdHost) as! String!) + "/api"
        }
        set {
            setPreference(object:newValue, forKey:PreferenceKeys.sabNZBdHost)
        }
    }
    
    class var sabNZBdApiKey: String {
        get {
            return getPreference(PreferenceKeys.sabNZBdApiKey) as! String!
        }
        set {
            setPreference(object:newValue, forKey:PreferenceKeys.sabNZBdApiKey)
        }
    }
    
    class var sickbeardHost: String {
        get {
            return cleanupHost(getPreference(PreferenceKeys.sickbeardHost) as! String!) + "/api"
        }
        set {
            setPreference(object:newValue, forKey:PreferenceKeys.sickbeardHost)
        }
    }
    
    class var sickbeardApiKey: String {
        get {
            return getPreference(PreferenceKeys.sickbeardApiKey) as! String!
        }
        set {
            setPreference(object:newValue, forKey:PreferenceKeys.sickbeardApiKey)
        }
    }
    
    class var couchPotatoHost: String {
        get {
            return cleanupHost(getPreference(PreferenceKeys.couchPotatoHost) as! String!)
        }
        set {
            setPreference(object:newValue, forKey:PreferenceKeys.couchPotatoHost)
        }
    }
    
    class var couchPotatoApiKey: String {
        get {
            return getPreference(PreferenceKeys.couchPotatoApiKey) as! String!
        }
        set {
            setPreference(object:newValue, forKey:PreferenceKeys.couchPotatoApiKey)
        }
    }
    
    //MARK: - Private functions
    
    internal class func getPreference(preferenceKey: String) -> AnyObject? {
        return NSUserDefaults.standardUserDefaults().objectForKey(preferenceKey)
    }
    
    internal class func setPreference(object object: String, forKey key:String) {
        NSUserDefaults.standardUserDefaults().setObject(object, forKey: key)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    private class func cleanupHost(host: String) -> String {
        var cleanedHost = host
        if host.rangeOfString("http://") == nil {
            cleanedHost = "http://" + host
        }
        return cleanedHost
    }
}