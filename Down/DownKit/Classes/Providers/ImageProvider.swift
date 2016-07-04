//
//  ImageProvider.swift
//  Down
//
//  Created by Ruud Puts on 19/08/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import UIKit

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
        return UIApplication.documentsDirectory + "/sickbeard/banners/\(tvdbid).png"
    }
    
    internal class func hasPosterForShow(tvdbid: Int) -> Bool {
        let posterPath = posterPathForShow(tvdbid)
        return fileExists(posterPath)
    }
    
    internal class func storePoster(poster: NSData, forShow tvdbid: Int) {
        let posterPath = posterPathForShow(tvdbid)
        storeImage(poster, atPath:posterPath)
        
        storePosterThumbnail(poster, forShow:tvdbid)
    }
    
    private class func storePosterThumbnail(posterData: NSData, forShow tvdbid: Int) {
        let poster = UIImage(data: posterData)!.resize(scale: 0.25)
        
        let thumbnailPath = posterThumbnailPathForShow(tvdbid)
        storeImage(UIImagePNGRepresentation(poster)!, atPath:thumbnailPath)
    }
    
    internal class func posterForShow(tvdbid: Int) -> UIImage? {
        let posterPath = posterPathForShow(tvdbid)
        return loadImage(posterPath)
    }
    
    internal class func posterThumbnailForShow(tvdbid: Int) -> UIImage? {
        let posterPath = posterThumbnailPathForShow(tvdbid)
        return loadImage(posterPath)
    }
    
    private class func posterPathForShow(tvdbid: Int) -> String {
        return UIApplication.documentsDirectory + "/sickbeard/posters/\(tvdbid).png"
    }
    
    private class func posterThumbnailPathForShow(tvdbid: Int) -> String {
        return UIApplication.documentsDirectory + "/sickbeard/posters/\(tvdbid)_thumb.png"
    }
}