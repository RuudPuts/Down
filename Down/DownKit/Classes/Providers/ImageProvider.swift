//
//  ImageProvider.swift
//  Down
//
//  Created by Ruud Puts on 19/08/15.
//  Copyright © 2015 Ruud Puts. All rights reserved.
//

import UIKit

public class ImageProvider: DownCache {
    
    fileprivate static var defaultPoster: Data?
    fileprivate static var defaultBanner: Data?
    
    fileprivate static let diskQueue: DispatchQueue = DispatchQueue(label: "com.ruudputs.down.ImageQueue", attributes: [])
    
    fileprivate class func fileExists(_ filepath: String) -> Bool {
        return FileManager.default.fileExists(atPath: filepath)
    }
    
    fileprivate class func ensureFilepath(_ filepath: String) {
        let filepathUrl = URL(fileURLWithPath: filepath, isDirectory: false)
        let fileDirectory = filepath.replacingOccurrences(of: filepathUrl.lastPathComponent, with: "")
        
        var isDirectory: ObjCBool = false
        if !FileManager.default.fileExists(atPath: fileDirectory, isDirectory: &isDirectory) {
            do {
                try FileManager.default.createDirectory(atPath: fileDirectory, withIntermediateDirectories: true, attributes: nil)
                NSLog("Created directory: \(fileDirectory)")
            }
            catch let error as NSError {
                NSLog("Exception while creating directory: \(filepath) \nError: \(error.localizedDescription)")
            }
        }
    }
    
    fileprivate class func storeImage(_ image: Data, atPath filepath: String) {
        ensureFilepath(filepath)
        diskQueue.async(execute: {
            do {
                try image.write(to: URL(fileURLWithPath: filepath), options: [.atomic])
            }
            catch let error as NSError {
                NSLog("Error while storing image: \(error.localizedDescription)")
            }
        })
    }
    
    fileprivate class func loadImage(_ filepath: String) -> UIImage? {
        var image: UIImage?
        if fileExists(filepath) {
            image = UIImage(contentsOfFile: filepath)
        }
        return image
    }
    
    public static func clearCache() {
        do {
            let sickbeardBannerPath = UIApplication.documentsDirectory + "/sickbeard/banners"
            let sickbeardPosterPath = UIApplication.documentsDirectory + "/sickbeard/posters"
            
            try FileManager.default.removeItem(atPath: sickbeardBannerPath)
            try FileManager.default.removeItem(atPath: sickbeardPosterPath)
        }
        catch let error as NSError {
            NSLog("Error while clearing ImageProvider: \(error)")
        }
    }
    
}

// MARK: Sickbeard extension
extension ImageProvider {
    
    internal class func hasBannerForShow(_ tvdbid: Int) -> Bool {
        let bannerPath = bannerPathForShow(tvdbid)
        return fileExists(bannerPath)
    }
    
    internal class func storeBanner(_ banner: Data, forShow tvdbid: Int) {
        guard tvdbid != 0 else {
            NSLog("[ImageProvider] Storing default banner")
            defaultBanner = banner
            return
        }
        
        guard banner != defaultBanner else {
            NSLog("[ImageProvider] Trying to store placeholder banner for \(tvdbid)")
            return
        }
        
        let bannerPath = bannerPathForShow(tvdbid)
        storeImage(banner, atPath:bannerPath)
    }
    
    internal class func bannerForShow(_ tvdbid: Int) -> UIImage? {
        let bannerPath = bannerPathForShow(tvdbid)
        return loadImage(bannerPath)
    }
    
    fileprivate class func bannerPathForShow(_ tvdbid: Int) -> String {
        return UIApplication.documentsDirectory + "/sickbeard/banners/\(tvdbid).png"
    }
    
    internal class func hasPosterForShow(_ tvdbid: Int) -> Bool {
        let posterPath = posterPathForShow(tvdbid)
        return fileExists(posterPath)
    }
    
    internal class func storePoster(_ poster: Data, forShow tvdbid: Int) {
        guard tvdbid != 0 else {
            NSLog("[ImageProvider] Storing default poster")
            defaultPoster = poster
            return
        }
        
        guard poster != defaultPoster else {
            NSLog("[ImageProvider] Trying to store placeholder poster for \(tvdbid)")
            return
        }
        
        let posterPath = posterPathForShow(tvdbid)
        storeImage(poster, atPath:posterPath)
        
        storePosterThumbnail(poster, forShow:tvdbid)
    }
    
    fileprivate class func storePosterThumbnail(_ posterData: Data, forShow tvdbid: Int) {
        let poster = UIImage(data: posterData)!.resize(scale: 0.25)
        
        let thumbnailPath = posterThumbnailPathForShow(tvdbid)
        storeImage(UIImagePNGRepresentation(poster)!, atPath:thumbnailPath)
    }
    
    internal class func posterForShow(_ tvdbid: Int) -> UIImage? {
        let posterPath = posterPathForShow(tvdbid)
        return loadImage(posterPath)
    }
    
    internal class func posterThumbnailForShow(_ tvdbid: Int) -> UIImage? {
        let posterPath = posterThumbnailPathForShow(tvdbid)
        return loadImage(posterPath)
    }
    
    fileprivate class func posterPathForShow(_ tvdbid: Int) -> String {
        return UIApplication.documentsDirectory + "/sickbeard/posters/\(tvdbid).png"
    }
    
    fileprivate class func posterThumbnailPathForShow(_ tvdbid: Int) -> String {
        return UIApplication.documentsDirectory + "/sickbeard/posters/\(tvdbid)_thumb.png"
    }
}
