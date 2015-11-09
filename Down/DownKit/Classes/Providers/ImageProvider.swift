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
    
    private class func fileExists(filepath: String) -> Bool {
        return NSFileManager.defaultManager().fileExistsAtPath(filepath)
    }
    
    private class func ensureFilepath(filepath: String) {
        let filepathUrl = NSURL(fileURLWithPath: filepath, isDirectory: false)
        let fileDirectory = filepath.stringByReplacingOccurrencesOfString(filepathUrl.lastPathComponent!, withString: "")
        
        var isDirectory: ObjCBool = false
        if !NSFileManager.defaultManager().fileExistsAtPath(fileDirectory, isDirectory: &isDirectory) {
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(fileDirectory, withIntermediateDirectories: true, attributes: nil)
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
    
}

// MARK: Sickbeard extension
extension ImageProvider {
    internal class func hasBannerForShow(tvdbid: String) -> Bool {
        let bannerPath = bannerPathForShow(tvdbid)
        return fileExists(bannerPath)
    }
    
    internal class func storeBanner(banner: NSData, forShow tvdbid: String) {
        let bannerPath = bannerPathForShow(tvdbid)
        storeImage(banner, atPath:bannerPath)
    }
    
    internal class func bannerForShow(tvdbid: String) -> UIImage? {
        let bannerPath = bannerPathForShow(tvdbid)
        return loadImage(bannerPath)
    }
    
    private class func bannerPathForShow(tvdbid: String) -> String {
        return UIApplication.documentsDirectory + "/sickbeard/banners/\(tvdbid).png"
    }
    
    internal class func hasPosterForShow(tvdbid: String) -> Bool {
        let posterPath = posterPathForShow(tvdbid)
        return fileExists(posterPath)
    }
    
    internal class func storePoster(poster: NSData, forShow tvdbid: String) {
        let posterPath = posterPathForShow(tvdbid)
        storeImage(poster, atPath:posterPath)
    }
    
    internal class func posterForShow(tvdbid: String) -> UIImage? {
        let posterPath = posterPathForShow(tvdbid)
        return loadImage(posterPath)
    }
    
    private class func posterPathForShow(tvdbid: String) -> String {
        return UIApplication.documentsDirectory + "/sickbeard/posters/\(tvdbid).png"
    }
}