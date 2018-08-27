//
//  AssetStorage.swift
//  DownKit
//
//  Created by Ruud Puts on 26/08/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import Foundation

public class AssetStorage {
}

public typealias DvrAssetStorage = AssetStorage
public extension DvrAssetStorage {
    static func banner(for show: DvrShow) -> UIImage? {
        return loadImage(bannerPath(for: show))
    }

    static func poster(for show: DvrShow) -> UIImage? {
        return loadImage(posterPath(for: show))
    }
}
extension DvrAssetStorage {
    static func store(banner: UIImage, for show: DvrShow) {
        store(image: banner, atPath: bannerPath(for: show))
    }

    static func store(poster: UIImage, for show: DvrShow) {
        store(image: poster, atPath: posterPath(for: show))
    }
}

private extension DvrAssetStorage {
    static var basePath = UIApplication.documentsDirectory

    static func bannerPath(for show: DvrShow) -> String {
        return basePath + "/dvr/banners/\(show.identifier).png"
    }

    static func posterPath(for show: DvrShow) -> String {
        return basePath + "/dvr/posters/\(show.identifier).png"
    }
}

private extension AssetStorage {
    static let diskQueue = DispatchQueue(label: "com.ruudputs.down.ImageQueue", attributes: [])

    static func fileExists(_ filepath: String) -> Bool {
        return FileManager.default.fileExists(atPath: filepath)
    }

    static func ensureFilepath(_ filepath: String) {
        let filepathUrl = URL(fileURLWithPath: filepath, isDirectory: false)
        let fileDirectory = filepath.replacingOccurrences(of: filepathUrl.lastPathComponent, with: "")

        var isDirectory: ObjCBool = false
        if !FileManager.default.fileExists(atPath: fileDirectory, isDirectory: &isDirectory) {
            do {
                try FileManager.default.createDirectory(atPath: fileDirectory,
                                                        withIntermediateDirectories: true,
                                                        attributes: nil)
                NSLog("Created directory: \(fileDirectory)")
            }
            catch {
                NSLog("Exception while creating directory: \(filepath) \nError: \(error.localizedDescription)")
            }
        }
    }

    static func store(image: UIImage, atPath filepath: String) {
        guard let data = UIImagePNGRepresentation(image) else {
            return
        }

        store(data: data, atPath: filepath)
    }

    static func store(data: Data, atPath filepath: String) {
        ensureFilepath(filepath)
        diskQueue.async(execute: {
            do {
                try data.write(to: URL(fileURLWithPath: filepath), options: [.atomic])
            }
            catch {
                NSLog("Error while storing image: \(error.localizedDescription)")
            }
        })
    }

    static func loadImage(_ filepath: String) -> UIImage? {
        var image: UIImage?
        if fileExists(filepath) {
            image = UIImage(contentsOfFile: filepath)
        }
        return image
    }
}

extension UIApplication {
    static var documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
}
