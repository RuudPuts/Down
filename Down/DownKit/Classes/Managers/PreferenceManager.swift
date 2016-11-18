//
//  Preferences.swift
//  Down
//
//  Created by Ruud Puts on 24/03/15.
//  Copyright (c) 2015 Ruud Puts. All rights reserved.
//

import Foundation

public class Preferences: DownCache {
    
    struct PreferenceKeys {
        static let sabNZBdHost = "SabNZBdHost"
        static let sabNZBdApiKey = "SabNZBdApiKey"
        
        static let sickbeardHost = "SickbeardHost"
        static let sickbeardApiKey = "SickbeardApiKey"
        static let sickbeardCacheRefreshKey = "SickbeardCacheRefreshKey"
        
        static let couchPotatoHost = "CouchPotatoHost"
        static let couchPotatoApiKey = "CouchPotatoApiKey"
        
        static let downRefreshSickbeardCache = "DownRefreshSickbeardCache"
        static let downClearCache = "DownClearCache"
    }
    
    public class var sabNZBdHost: String {
        get {
            let host = getPreference(PreferenceKeys.sabNZBdHost) as! String?
            if host == nil || host == "http://ip:port" {
                return ""
            }
            
            return cleanupHost(host!)
        }
        set {
            setPreference(newValue as AnyObject?, forKey:PreferenceKeys.sabNZBdHost)
        }
    }
    
    public class var sabNZBdApiKey: String {
        get {
            return getPreference(PreferenceKeys.sabNZBdApiKey) as! String? ?? ""
        }
        set {
            setPreference(newValue as AnyObject?, forKey:PreferenceKeys.sabNZBdApiKey)
        }
    }
    
    public class var sickbeardHost: String {
        get {
            let host = getPreference(PreferenceKeys.sickbeardHost) as! String?
            if host == nil || host == "ip:port" {
                return ""
            }
            
            return cleanupHost(host!)
        }
        set {
            setPreference(newValue as AnyObject?, forKey:PreferenceKeys.sickbeardHost)
        }
    }
    
    public class var sickbeardApiKey: String {
        get {
            return getPreference(PreferenceKeys.sickbeardApiKey) as! String? ?? ""
        }
        set {
            setPreference(newValue as AnyObject?, forKey:PreferenceKeys.sickbeardApiKey)
        }
    }
    
    public class var sickbeardLastCacheRefresh: Date? {
        get {
            return getPreference(PreferenceKeys.sickbeardCacheRefreshKey) as! Date?
        }
        set {
            setPreference(newValue as AnyObject?, forKey:PreferenceKeys.sickbeardCacheRefreshKey)
        }
    }
    
    public class var couchPotatoHost: String {
        get {
            let host = getPreference(PreferenceKeys.sabNZBdHost) as! String?
            if host == nil || host == "ip:port" {
                return ""
            }
            
            return cleanupHost(host!)
        }
        set {
            setPreference(newValue as AnyObject?, forKey:PreferenceKeys.couchPotatoHost)
        }
    }
    
    public class var couchPotatoApiKey: String {
        get {
            return getPreference(PreferenceKeys.couchPotatoApiKey) as! String? ?? ""
        }
        set {
            setPreference(newValue as AnyObject?, forKey:PreferenceKeys.couchPotatoApiKey)
        }
    }
    
    public class var downRefreshSickbeardCache: Bool {
        get {
            return getPreference(PreferenceKeys.downRefreshSickbeardCache) as! Bool? ?? false
        }
        set {
            setPreference(newValue as AnyObject?, forKey:PreferenceKeys.downRefreshSickbeardCache)
        }
    }
    
    public class var downClearCache: Bool {
        get {
            return getPreference(PreferenceKeys.downClearCache) as! Bool? ?? false
        }
        set {
            setPreference(newValue as AnyObject?, forKey:PreferenceKeys.downClearCache)
        }
    }
    
    // MARK: - DownCache
    
    public static func clearCache() {
        deletePreference(PreferenceKeys.sabNZBdHost)
        deletePreference(PreferenceKeys.sabNZBdApiKey)
        
        deletePreference(PreferenceKeys.sickbeardHost)
        deletePreference(PreferenceKeys.sickbeardApiKey)
        deletePreference(PreferenceKeys.sickbeardCacheRefreshKey)
        
        deletePreference(PreferenceKeys.couchPotatoHost)
        deletePreference(PreferenceKeys.couchPotatoApiKey)
        
        deletePreference(PreferenceKeys.downClearCache)
    }
    
    // MARK: - Private functions
    
    fileprivate class func getPreference(_ key: String) -> AnyObject? {
        return UserDefaults.standard.object(forKey: key) as AnyObject?
    }
    
    fileprivate class func setPreference(_ object: AnyObject?, forKey key: String) {
        UserDefaults.standard.set(object, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    fileprivate class func deletePreference(_ key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    fileprivate class func cleanupHost(_ host: String) -> String {
        var cleanedHost = host
        if host.range(of: "http://") == nil {
            cleanedHost = "http://" + host
        }
        return cleanedHost
    }
}
