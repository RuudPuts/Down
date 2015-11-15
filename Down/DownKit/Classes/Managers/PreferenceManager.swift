//
//  PreferenceManager.swift
//  Down
//
//  Created by Ruud Puts on 24/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import Foundation

public class PreferenceManager {
    
    struct PreferenceKeys {
        static let sabNZBdHost = "SabNZBdHost"
        static let sabNZBdApiKey = "SabNZBdApiKey"
        
        static let sickbeardHost = "SickbeardHost"
        static let sickbeardApiKey = "SickbeardApiKey"
        
        static let couchPotatoHost = "CouchPotatoHost"
        static let couchPotatoApiKey = "CouchPotatoApiKey"
    }
    
    public class var sabNZBdHost: String {
        get {
            return getPreference(PreferenceKeys.sabNZBdHost)
        }
        set {
            setPreference(newValue, forKey:PreferenceKeys.sabNZBdHost)
        }
    }
    
    public class var sabNZBdApiKey: String {
        get {
            return getPreference(PreferenceKeys.sabNZBdApiKey)
        }
        set {
            setPreference(newValue, forKey:PreferenceKeys.sabNZBdApiKey)
        }
    }
    
    public class var sickbeardHost: String {
        get {
            return getPreference(PreferenceKeys.sickbeardHost)
        }
        set {
            setPreference(newValue, forKey:PreferenceKeys.sickbeardHost)
        }
    }
    
    public class var sickbeardApiKey: String {
        get {
            return getPreference(PreferenceKeys.sickbeardApiKey)
        }
        set {
            setPreference(newValue, forKey:PreferenceKeys.sickbeardApiKey)
        }
    }
    
    public class var couchPotatoHost: String {
        get {
            return getPreference(PreferenceKeys.couchPotatoHost)
        }
        set {
            setPreference(newValue, forKey:PreferenceKeys.couchPotatoHost)
        }
    }
    
    public class var couchPotatoApiKey: String {
        get {
            return getPreference(PreferenceKeys.couchPotatoApiKey)
        }
        set {
            setPreference(newValue, forKey:PreferenceKeys.couchPotatoApiKey)
        }
    }
    
    //MARK: - Private functions
    
    private class func getPreference(preferenceKey: String) -> String {
        return NSUserDefaults.standardUserDefaults().objectForKey(preferenceKey) as? String ?? ""
    }
    
    private class func setPreference(object: String, forKey key:String) {
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