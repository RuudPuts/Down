//
//  ImageProvider.swift
//  Down
//
//  Created by Ruud Puts on 19/08/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import Foundation

public class ImageProvider {
    
    private static let diskQueue: dispatch_queue_t = dispatch_queue_create("com.ruudputs.down.ImageQueue", DISPATCH_QUEUE_SERIAL)
    
    // MARK: Generic stuff
    
    private class var cacheDirectory: String {
        return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
    }
    
    private class func fileExists(filepath: String) -> Bool {
        return NSFileManager.defaultManager().fileExistsAtPath(filepath)
    }
    
    private class func ensureFilepath(filepath: String) {
        let filepathUrl = NSURL(fileURLWithPath: filepath, isDirectory: false)
        let fileDirectory = filepath.stringByReplacingOccurrencesOfString(filepathUrl.lastPathComponent!, withString: "")
        
        var isDirectory: ObjCBool = false
        if !NSFileManager.defaultManager().fileExistsAtPath(fileDirectory, isDirectory: &isDirectory) {
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(fileDirectory, withIntermediateDirectories: false, attributes: nil)
                print("Created directory: \(fileDirectory)")
            }
            catch let error as NSError {
                print("Exception while creating directory: \(filepath) \nError: \(error.localizedDescription)")
            }
        }
    }
    
    private class func storeImage(image: NSData, atPath filepath: String) {
        ensureFilepath(filepath)
        dispatch_async(diskQueue, {
            image.writeToFile(filepath, atomically: true)
        })
    }
    
    private class func loadImage(filepath: String) -> UIImage? {
        var image: UIImage?
        if fileExists(filepath) {
            image = UIImage(contentsOfFile: filepath)
        }
        return image
    }
    
    // MARK: Sickbeard banners
    
    internal class func hasBannerForShow(tvdbid: Int) -> Bool {
        let bannerPath = bannerPathForShow(tvdbid)
        return fileExists(bannerPath)
    }
    
    internal class func storeBanner(banner: NSData, forShow tvdbid: Int) {
        let bannerPath = bannerPathForShow(tvdbid)
        storeImage(banner, atPath:bannerPath)
    }
    
    internal class func bannerForShow(tvdbid: Int) -> UIImage? {
        let bannerPath = bannerPathForShow(tvdbid)
        return loadImage(bannerPath)
    }
    
    private class func bannerPathForShow(tvdbid: Int) -> String {
        return cacheDirectory + "/banners/\(tvdbid).png"
    }
    
}