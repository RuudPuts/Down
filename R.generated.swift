//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap(Locale.init) ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)
  
  static func validate() throws {
    try font.validate()
    try intern.validate()
  }
  
  /// This `R.color` struct is generated, and contains static references to 0 colors.
  struct color {
    fileprivate init() {}
  }
  
  /// This `R.file` struct is generated, and contains static references to 10 files.
  struct file {
    /// Resource file `OpenSans-Bold.ttf`.
    static let openSansBoldTtf = Rswift.FileResource(bundle: R.hostingBundle, name: "OpenSans-Bold", pathExtension: "ttf")
    /// Resource file `OpenSans-BoldItalic.ttf`.
    static let openSansBoldItalicTtf = Rswift.FileResource(bundle: R.hostingBundle, name: "OpenSans-BoldItalic", pathExtension: "ttf")
    /// Resource file `OpenSans-ExtraBold.ttf`.
    static let openSansExtraBoldTtf = Rswift.FileResource(bundle: R.hostingBundle, name: "OpenSans-ExtraBold", pathExtension: "ttf")
    /// Resource file `OpenSans-ExtraBoldItalic.ttf`.
    static let openSansExtraBoldItalicTtf = Rswift.FileResource(bundle: R.hostingBundle, name: "OpenSans-ExtraBoldItalic", pathExtension: "ttf")
    /// Resource file `OpenSans-Italic.ttf`.
    static let openSansItalicTtf = Rswift.FileResource(bundle: R.hostingBundle, name: "OpenSans-Italic", pathExtension: "ttf")
    /// Resource file `OpenSans-Light.ttf`.
    static let openSansLightTtf = Rswift.FileResource(bundle: R.hostingBundle, name: "OpenSans-Light", pathExtension: "ttf")
    /// Resource file `OpenSans-LightItalic.ttf`.
    static let openSansLightItalicTtf = Rswift.FileResource(bundle: R.hostingBundle, name: "OpenSans-LightItalic", pathExtension: "ttf")
    /// Resource file `OpenSans-Regular.ttf`.
    static let openSansRegularTtf = Rswift.FileResource(bundle: R.hostingBundle, name: "OpenSans-Regular", pathExtension: "ttf")
    /// Resource file `OpenSans-Semibold.ttf`.
    static let openSansSemiboldTtf = Rswift.FileResource(bundle: R.hostingBundle, name: "OpenSans-Semibold", pathExtension: "ttf")
    /// Resource file `OpenSans-SemiboldItalic.ttf`.
    static let openSansSemiboldItalicTtf = Rswift.FileResource(bundle: R.hostingBundle, name: "OpenSans-SemiboldItalic", pathExtension: "ttf")
    
    /// `bundle.url(forResource: "OpenSans-Bold", withExtension: "ttf")`
    static func openSansBoldTtf(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.openSansBoldTtf
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    /// `bundle.url(forResource: "OpenSans-BoldItalic", withExtension: "ttf")`
    static func openSansBoldItalicTtf(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.openSansBoldItalicTtf
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    /// `bundle.url(forResource: "OpenSans-ExtraBold", withExtension: "ttf")`
    static func openSansExtraBoldTtf(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.openSansExtraBoldTtf
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    /// `bundle.url(forResource: "OpenSans-ExtraBoldItalic", withExtension: "ttf")`
    static func openSansExtraBoldItalicTtf(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.openSansExtraBoldItalicTtf
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    /// `bundle.url(forResource: "OpenSans-Italic", withExtension: "ttf")`
    static func openSansItalicTtf(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.openSansItalicTtf
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    /// `bundle.url(forResource: "OpenSans-Light", withExtension: "ttf")`
    static func openSansLightTtf(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.openSansLightTtf
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    /// `bundle.url(forResource: "OpenSans-LightItalic", withExtension: "ttf")`
    static func openSansLightItalicTtf(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.openSansLightItalicTtf
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    /// `bundle.url(forResource: "OpenSans-Regular", withExtension: "ttf")`
    static func openSansRegularTtf(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.openSansRegularTtf
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    /// `bundle.url(forResource: "OpenSans-Semibold", withExtension: "ttf")`
    static func openSansSemiboldTtf(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.openSansSemiboldTtf
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    /// `bundle.url(forResource: "OpenSans-SemiboldItalic", withExtension: "ttf")`
    static func openSansSemiboldItalicTtf(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.openSansSemiboldItalicTtf
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.font` struct is generated, and contains static references to 10 fonts.
  struct font: Rswift.Validatable {
    /// Font `OpenSans-BoldItalic`.
    static let openSansBoldItalic = Rswift.FontResource(fontName: "OpenSans-BoldItalic")
    /// Font `OpenSans-Bold`.
    static let openSansBold = Rswift.FontResource(fontName: "OpenSans-Bold")
    /// Font `OpenSans-ExtraboldItalic`.
    static let openSansExtraboldItalic = Rswift.FontResource(fontName: "OpenSans-ExtraboldItalic")
    /// Font `OpenSans-Extrabold`.
    static let openSansExtrabold = Rswift.FontResource(fontName: "OpenSans-Extrabold")
    /// Font `OpenSans-Italic`.
    static let openSansItalic = Rswift.FontResource(fontName: "OpenSans-Italic")
    /// Font `OpenSans-Light`.
    static let openSansLight = Rswift.FontResource(fontName: "OpenSans-Light")
    /// Font `OpenSans-SemiboldItalic`.
    static let openSansSemiboldItalic = Rswift.FontResource(fontName: "OpenSans-SemiboldItalic")
    /// Font `OpenSans-Semibold`.
    static let openSansSemibold = Rswift.FontResource(fontName: "OpenSans-Semibold")
    /// Font `OpenSansLight-Italic`.
    static let openSansLightItalic = Rswift.FontResource(fontName: "OpenSansLight-Italic")
    /// Font `OpenSans`.
    static let openSans = Rswift.FontResource(fontName: "OpenSans")
    
    /// `UIFont(name: "OpenSans", size: ...)`
    static func openSans(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: openSans, size: size)
    }
    
    /// `UIFont(name: "OpenSans-Bold", size: ...)`
    static func openSansBold(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: openSansBold, size: size)
    }
    
    /// `UIFont(name: "OpenSans-BoldItalic", size: ...)`
    static func openSansBoldItalic(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: openSansBoldItalic, size: size)
    }
    
    /// `UIFont(name: "OpenSans-Extrabold", size: ...)`
    static func openSansExtrabold(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: openSansExtrabold, size: size)
    }
    
    /// `UIFont(name: "OpenSans-ExtraboldItalic", size: ...)`
    static func openSansExtraboldItalic(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: openSansExtraboldItalic, size: size)
    }
    
    /// `UIFont(name: "OpenSans-Italic", size: ...)`
    static func openSansItalic(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: openSansItalic, size: size)
    }
    
    /// `UIFont(name: "OpenSans-Light", size: ...)`
    static func openSansLight(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: openSansLight, size: size)
    }
    
    /// `UIFont(name: "OpenSans-Semibold", size: ...)`
    static func openSansSemibold(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: openSansSemibold, size: size)
    }
    
    /// `UIFont(name: "OpenSans-SemiboldItalic", size: ...)`
    static func openSansSemiboldItalic(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: openSansSemiboldItalic, size: size)
    }
    
    /// `UIFont(name: "OpenSansLight-Italic", size: ...)`
    static func openSansLightItalic(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: openSansLightItalic, size: size)
    }
    
    static func validate() throws {
      if R.font.openSansExtrabold(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'OpenSans-Extrabold' could not be loaded, is 'OpenSans-ExtraBold.ttf' added to the UIAppFonts array in this targets Info.plist?") }
      if R.font.openSansSemiboldItalic(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'OpenSans-SemiboldItalic' could not be loaded, is 'OpenSans-SemiboldItalic.ttf' added to the UIAppFonts array in this targets Info.plist?") }
      if R.font.openSansItalic(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'OpenSans-Italic' could not be loaded, is 'OpenSans-Italic.ttf' added to the UIAppFonts array in this targets Info.plist?") }
      if R.font.openSansSemibold(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'OpenSans-Semibold' could not be loaded, is 'OpenSans-Semibold.ttf' added to the UIAppFonts array in this targets Info.plist?") }
      if R.font.openSans(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'OpenSans' could not be loaded, is 'OpenSans-Regular.ttf' added to the UIAppFonts array in this targets Info.plist?") }
      if R.font.openSansLight(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'OpenSans-Light' could not be loaded, is 'OpenSans-Light.ttf' added to the UIAppFonts array in this targets Info.plist?") }
      if R.font.openSansBold(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'OpenSans-Bold' could not be loaded, is 'OpenSans-Bold.ttf' added to the UIAppFonts array in this targets Info.plist?") }
      if R.font.openSansBoldItalic(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'OpenSans-BoldItalic' could not be loaded, is 'OpenSans-BoldItalic.ttf' added to the UIAppFonts array in this targets Info.plist?") }
      if R.font.openSansExtraboldItalic(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'OpenSans-ExtraboldItalic' could not be loaded, is 'OpenSans-ExtraBoldItalic.ttf' added to the UIAppFonts array in this targets Info.plist?") }
      if R.font.openSansLightItalic(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'OpenSansLight-Italic' could not be loaded, is 'OpenSans-LightItalic.ttf' added to the UIAppFonts array in this targets Info.plist?") }
    }
    
    fileprivate init() {}
  }
  
  /// This `R.image` struct is generated, and contains static references to 15 images.
  struct image {
    /// Image `couchpotato_icon`.
    static let couchpotato_icon = Rswift.ImageResource(bundle: R.hostingBundle, name: "couchpotato_icon")
    /// Image `icon_close`.
    static let icon_close = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_close")
    /// Image `icon_gear`.
    static let icon_gear = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_gear")
    /// Image `icon_history`.
    static let icon_history = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_history")
    /// Image `icon_queue`.
    static let icon_queue = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_queue")
    /// Image `icon_settings`.
    static let icon_settings = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_settings")
    /// Image `icon_x`.
    static let icon_x = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_x")
    /// Image `logo`.
    static let logo = Rswift.ImageResource(bundle: R.hostingBundle, name: "logo")
    /// Image `sabnzbd_icon`.
    static let sabnzbd_icon = Rswift.ImageResource(bundle: R.hostingBundle, name: "sabnzbd_icon")
    /// Image `sickbeard_icon`.
    static let sickbeard_icon = Rswift.ImageResource(bundle: R.hostingBundle, name: "sickbeard_icon")
    /// Image `sickgear_icon`.
    static let sickgear_icon = Rswift.ImageResource(bundle: R.hostingBundle, name: "sickgear_icon")
    /// Image `tabbar_downloads`.
    static let tabbar_downloads = Rswift.ImageResource(bundle: R.hostingBundle, name: "tabbar_downloads")
    /// Image `tabbar_movies`.
    static let tabbar_movies = Rswift.ImageResource(bundle: R.hostingBundle, name: "tabbar_movies")
    /// Image `tabbar_settings`.
    static let tabbar_settings = Rswift.ImageResource(bundle: R.hostingBundle, name: "tabbar_settings")
    /// Image `tabbar_shows`.
    static let tabbar_shows = Rswift.ImageResource(bundle: R.hostingBundle, name: "tabbar_shows")
    
    /// `UIImage(named: "couchpotato_icon", bundle: ..., traitCollection: ...)`
    static func couchpotato_icon(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.couchpotato_icon, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_close", bundle: ..., traitCollection: ...)`
    static func icon_close(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_close, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_gear", bundle: ..., traitCollection: ...)`
    static func icon_gear(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_gear, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_history", bundle: ..., traitCollection: ...)`
    static func icon_history(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_history, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_queue", bundle: ..., traitCollection: ...)`
    static func icon_queue(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_queue, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_settings", bundle: ..., traitCollection: ...)`
    static func icon_settings(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_settings, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_x", bundle: ..., traitCollection: ...)`
    static func icon_x(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_x, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "logo", bundle: ..., traitCollection: ...)`
    static func logo(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.logo, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "sabnzbd_icon", bundle: ..., traitCollection: ...)`
    static func sabnzbd_icon(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.sabnzbd_icon, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "sickbeard_icon", bundle: ..., traitCollection: ...)`
    static func sickbeard_icon(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.sickbeard_icon, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "sickgear_icon", bundle: ..., traitCollection: ...)`
    static func sickgear_icon(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.sickgear_icon, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "tabbar_downloads", bundle: ..., traitCollection: ...)`
    static func tabbar_downloads(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.tabbar_downloads, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "tabbar_movies", bundle: ..., traitCollection: ...)`
    static func tabbar_movies(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.tabbar_movies, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "tabbar_settings", bundle: ..., traitCollection: ...)`
    static func tabbar_settings(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.tabbar_settings, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "tabbar_shows", bundle: ..., traitCollection: ...)`
    static func tabbar_shows(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.tabbar_shows, compatibleWith: traitCollection)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.nib` struct is generated, and contains static references to 20 nibs.
  struct nib {
    /// Nib `ApplicationHeaderView`.
    static let applicationHeaderView = _R.nib._ApplicationHeaderView()
    /// Nib `ApplicationSettingsViewController`.
    static let applicationSettingsViewController = _R.nib._ApplicationSettingsViewController()
    /// Nib `DmrStatusViewController`.
    static let dmrStatusViewController = _R.nib._DmrStatusViewController()
    /// Nib `DownloadItemCell`.
    static let downloadItemCell = _R.nib._DownloadItemCell()
    /// Nib `DownloadItemDetailViewController`.
    static let downloadItemDetailViewController = _R.nib._DownloadItemDetailViewController()
    /// Nib `DownloadQueueStatusView`.
    static let downloadQueueStatusView = _R.nib._DownloadQueueStatusView()
    /// Nib `DownloadStatusViewController`.
    static let downloadStatusViewController = _R.nib._DownloadStatusViewController()
    /// Nib `DvrAddShowViewController`.
    static let dvrAddShowViewController = _R.nib._DvrAddShowViewController()
    /// Nib `DvrAiringSoonCell`.
    static let dvrAiringSoonCell = _R.nib._DvrAiringSoonCell()
    /// Nib `DvrAiringSoonViewController`.
    static let dvrAiringSoonViewController = _R.nib._DvrAiringSoonViewController()
    /// Nib `DvrEpisodeCell`.
    static let dvrEpisodeCell = _R.nib._DvrEpisodeCell()
    /// Nib `DvrShowCollectionViewCell`.
    static let dvrShowCollectionViewCell = _R.nib._DvrShowCollectionViewCell()
    /// Nib `DvrShowDetailViewController`.
    static let dvrShowDetailViewController = _R.nib._DvrShowDetailViewController()
    /// Nib `DvrShowHeaderView`.
    static let dvrShowHeaderView = _R.nib._DvrShowHeaderView()
    /// Nib `DvrShowsViewController`.
    static let dvrShowsViewController = _R.nib._DvrShowsViewController()
    /// Nib `KeyValueTableViewCell`.
    static let keyValueTableViewCell = _R.nib._KeyValueTableViewCell()
    /// Nib `PagingViewController`.
    static let pagingViewController = _R.nib._PagingViewController()
    /// Nib `SettingsApplicationCell`.
    static let settingsApplicationCell = _R.nib._SettingsApplicationCell()
    /// Nib `SettingsViewController`.
    static let settingsViewController = _R.nib._SettingsViewController()
    /// Nib `TableHeaderView`.
    static let tableHeaderView = _R.nib._TableHeaderView()
    
    /// `UINib(name: "ApplicationHeaderView", in: bundle)`
    static func applicationHeaderView(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.applicationHeaderView)
    }
    
    /// `UINib(name: "ApplicationSettingsViewController", in: bundle)`
    static func applicationSettingsViewController(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.applicationSettingsViewController)
    }
    
    /// `UINib(name: "DmrStatusViewController", in: bundle)`
    static func dmrStatusViewController(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.dmrStatusViewController)
    }
    
    /// `UINib(name: "DownloadItemCell", in: bundle)`
    static func downloadItemCell(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.downloadItemCell)
    }
    
    /// `UINib(name: "DownloadItemDetailViewController", in: bundle)`
    static func downloadItemDetailViewController(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.downloadItemDetailViewController)
    }
    
    /// `UINib(name: "DownloadQueueStatusView", in: bundle)`
    static func downloadQueueStatusView(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.downloadQueueStatusView)
    }
    
    /// `UINib(name: "DownloadStatusViewController", in: bundle)`
    static func downloadStatusViewController(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.downloadStatusViewController)
    }
    
    /// `UINib(name: "DvrAddShowViewController", in: bundle)`
    static func dvrAddShowViewController(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.dvrAddShowViewController)
    }
    
    /// `UINib(name: "DvrAiringSoonCell", in: bundle)`
    static func dvrAiringSoonCell(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.dvrAiringSoonCell)
    }
    
    /// `UINib(name: "DvrAiringSoonViewController", in: bundle)`
    static func dvrAiringSoonViewController(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.dvrAiringSoonViewController)
    }
    
    /// `UINib(name: "DvrEpisodeCell", in: bundle)`
    static func dvrEpisodeCell(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.dvrEpisodeCell)
    }
    
    /// `UINib(name: "DvrShowCollectionViewCell", in: bundle)`
    static func dvrShowCollectionViewCell(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.dvrShowCollectionViewCell)
    }
    
    /// `UINib(name: "DvrShowDetailViewController", in: bundle)`
    static func dvrShowDetailViewController(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.dvrShowDetailViewController)
    }
    
    /// `UINib(name: "DvrShowHeaderView", in: bundle)`
    static func dvrShowHeaderView(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.dvrShowHeaderView)
    }
    
    /// `UINib(name: "DvrShowsViewController", in: bundle)`
    static func dvrShowsViewController(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.dvrShowsViewController)
    }
    
    /// `UINib(name: "KeyValueTableViewCell", in: bundle)`
    static func keyValueTableViewCell(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.keyValueTableViewCell)
    }
    
    /// `UINib(name: "PagingViewController", in: bundle)`
    static func pagingViewController(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.pagingViewController)
    }
    
    /// `UINib(name: "SettingsApplicationCell", in: bundle)`
    static func settingsApplicationCell(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.settingsApplicationCell)
    }
    
    /// `UINib(name: "SettingsViewController", in: bundle)`
    static func settingsViewController(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.settingsViewController)
    }
    
    /// `UINib(name: "TableHeaderView", in: bundle)`
    static func tableHeaderView(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.tableHeaderView)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.reuseIdentifier` struct is generated, and contains static references to 1 reuse identifiers.
  struct reuseIdentifier {
    /// Reuse identifier `DownloadItemCell`.
    static let downloadItemCell: Rswift.ReuseIdentifier<DownloadItemCell> = Rswift.ReuseIdentifier(identifier: "DownloadItemCell")
    
    fileprivate init() {}
  }
  
  /// This `R.segue` struct is generated, and contains static references to 0 view controllers.
  struct segue {
    fileprivate init() {}
  }
  
  /// This `R.storyboard` struct is generated, and contains static references to 1 storyboards.
  struct storyboard {
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()
    
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.string` struct is generated, and contains static references to 1 localization tables.
  struct string {
    /// This `R.string.localizable` struct is generated, and contains static references to 6 localization keys.
    struct localizable {
      /// en translation: Add new show
      /// 
      /// Locales: en
      static let dvr_screen_add_show_title = Rswift.StringResource(key: "dvr_screen_add_show_title", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Refreshing show cache...
      /// 
      /// Locales: en
      static let dvr_settings_cacherefresh_description = Rswift.StringResource(key: "dvr_settings_cacherefresh_description", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Remaining
      /// 
      /// Locales: en
      static let download_statusview_mbremaining = Rswift.StringResource(key: "download_statusview_mbremaining", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Speed
      /// 
      /// Locales: en
      static let download_statusview_speed = Rswift.StringResource(key: "download_statusview_speed", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Time left
      /// 
      /// Locales: en
      static let download_statusview_timeremaining = Rswift.StringResource(key: "download_statusview_timeremaining", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      /// en translation: Unaired
      /// 
      /// Locales: en
      static let dvr_episode_unaired = Rswift.StringResource(key: "dvr_episode_unaired", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en"], comment: nil)
      
      /// en translation: Add new show
      /// 
      /// Locales: en
      static func dvr_screen_add_show_title(_: Void = ()) -> String {
        return NSLocalizedString("dvr_screen_add_show_title", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Refreshing show cache...
      /// 
      /// Locales: en
      static func dvr_settings_cacherefresh_description(_: Void = ()) -> String {
        return NSLocalizedString("dvr_settings_cacherefresh_description", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Remaining
      /// 
      /// Locales: en
      static func download_statusview_mbremaining(_: Void = ()) -> String {
        return NSLocalizedString("download_statusview_mbremaining", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Speed
      /// 
      /// Locales: en
      static func download_statusview_speed(_: Void = ()) -> String {
        return NSLocalizedString("download_statusview_speed", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Time left
      /// 
      /// Locales: en
      static func download_statusview_timeremaining(_: Void = ()) -> String {
        return NSLocalizedString("download_statusview_timeremaining", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Unaired
      /// 
      /// Locales: en
      static func dvr_episode_unaired(_: Void = ()) -> String {
        return NSLocalizedString("dvr_episode_unaired", bundle: R.hostingBundle, comment: "")
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      try _R.validate()
    }
    
    fileprivate init() {}
  }
  
  fileprivate class Class {}
  
  fileprivate init() {}
}

struct _R: Rswift.Validatable {
  static func validate() throws {
    try storyboard.validate()
    try nib.validate()
  }
  
  struct nib: Rswift.Validatable {
    static func validate() throws {
      try _ApplicationHeaderView.validate()
      try _TableHeaderView.validate()
      try _SettingsApplicationCell.validate()
    }
    
    struct _ApplicationHeaderView: Rswift.NibResourceType, Rswift.Validatable {
      let bundle = R.hostingBundle
      let name = "ApplicationHeaderView"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [NSObject : AnyObject]? = nil) -> UIKit.UIView? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
      }
      
      static func validate() throws {
        if UIKit.UIImage(named: "sabnzbd_icon", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'sabnzbd_icon' is used in nib 'ApplicationHeaderView', but couldn't be loaded.") }
      }
      
      fileprivate init() {}
    }
    
    struct _ApplicationSettingsViewController: Rswift.NibResourceType {
      let bundle = R.hostingBundle
      let name = "ApplicationSettingsViewController"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [NSObject : AnyObject]? = nil) -> UIKit.UIView? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
      }
      
      fileprivate init() {}
    }
    
    struct _DmrStatusViewController: Rswift.NibResourceType {
      let bundle = R.hostingBundle
      let name = "DmrStatusViewController"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [NSObject : AnyObject]? = nil) -> UIKit.UIView? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
      }
      
      fileprivate init() {}
    }
    
    struct _DownloadItemCell: Rswift.NibResourceType, Rswift.ReuseIdentifierType {
      typealias ReusableType = DownloadItemCell
      
      let bundle = R.hostingBundle
      let identifier = "DownloadItemCell"
      let name = "DownloadItemCell"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [NSObject : AnyObject]? = nil) -> DownloadItemCell? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? DownloadItemCell
      }
      
      fileprivate init() {}
    }
    
    struct _DownloadItemDetailViewController: Rswift.NibResourceType {
      let bundle = R.hostingBundle
      let name = "DownloadItemDetailViewController"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [NSObject : AnyObject]? = nil) -> UIKit.UIView? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
      }
      
      fileprivate init() {}
    }
    
    struct _DownloadQueueStatusView: Rswift.NibResourceType {
      let bundle = R.hostingBundle
      let name = "DownloadQueueStatusView"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [NSObject : AnyObject]? = nil) -> UIKit.UIView? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
      }
      
      fileprivate init() {}
    }
    
    struct _DownloadStatusViewController: Rswift.NibResourceType {
      let bundle = R.hostingBundle
      let name = "DownloadStatusViewController"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [NSObject : AnyObject]? = nil) -> UIKit.UIView? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
      }
      
      fileprivate init() {}
    }
    
    struct _DvrAddShowViewController: Rswift.NibResourceType {
      let bundle = R.hostingBundle
      let name = "DvrAddShowViewController"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [NSObject : AnyObject]? = nil) -> UIKit.UIView? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
      }
      
      fileprivate init() {}
    }
    
    struct _DvrAiringSoonCell: Rswift.NibResourceType {
      let bundle = R.hostingBundle
      let name = "DvrAiringSoonCell"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [NSObject : AnyObject]? = nil) -> DvrAiringSoonCell? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? DvrAiringSoonCell
      }
      
      fileprivate init() {}
    }
    
    struct _DvrAiringSoonViewController: Rswift.NibResourceType {
      let bundle = R.hostingBundle
      let name = "DvrAiringSoonViewController"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [NSObject : AnyObject]? = nil) -> UIKit.UIView? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
      }
      
      fileprivate init() {}
    }
    
    struct _DvrEpisodeCell: Rswift.NibResourceType {
      let bundle = R.hostingBundle
      let name = "DvrEpisodeCell"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [NSObject : AnyObject]? = nil) -> DvrEpisodeCell? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? DvrEpisodeCell
      }
      
      fileprivate init() {}
    }
    
    struct _DvrShowCollectionViewCell: Rswift.NibResourceType {
      let bundle = R.hostingBundle
      let name = "DvrShowCollectionViewCell"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [NSObject : AnyObject]? = nil) -> DvrShowCollectionViewCell? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? DvrShowCollectionViewCell
      }
      
      fileprivate init() {}
    }
    
    struct _DvrShowDetailViewController: Rswift.NibResourceType {
      let bundle = R.hostingBundle
      let name = "DvrShowDetailViewController"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [NSObject : AnyObject]? = nil) -> UIKit.UIView? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
      }
      
      fileprivate init() {}
    }
    
    struct _DvrShowHeaderView: Rswift.NibResourceType {
      let bundle = R.hostingBundle
      let name = "DvrShowHeaderView"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [NSObject : AnyObject]? = nil) -> UIKit.UIView? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
      }
      
      fileprivate init() {}
    }
    
    struct _DvrShowsViewController: Rswift.NibResourceType {
      let bundle = R.hostingBundle
      let name = "DvrShowsViewController"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [NSObject : AnyObject]? = nil) -> UIKit.UIView? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
      }
      
      fileprivate init() {}
    }
    
    struct _KeyValueTableViewCell: Rswift.NibResourceType {
      let bundle = R.hostingBundle
      let name = "KeyValueTableViewCell"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [NSObject : AnyObject]? = nil) -> KeyValueTableViewCell? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? KeyValueTableViewCell
      }
      
      fileprivate init() {}
    }
    
    struct _PagingViewController: Rswift.NibResourceType {
      let bundle = R.hostingBundle
      let name = "PagingViewController"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [NSObject : AnyObject]? = nil) -> UIKit.UIView? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
      }
      
      fileprivate init() {}
    }
    
    struct _SettingsApplicationCell: Rswift.NibResourceType, Rswift.Validatable {
      let bundle = R.hostingBundle
      let name = "SettingsApplicationCell"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [NSObject : AnyObject]? = nil) -> SettingsApplicationCell? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? SettingsApplicationCell
      }
      
      static func validate() throws {
        if UIKit.UIImage(named: "sabnzbd_icon", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'sabnzbd_icon' is used in nib 'SettingsApplicationCell', but couldn't be loaded.") }
      }
      
      fileprivate init() {}
    }
    
    struct _SettingsViewController: Rswift.NibResourceType {
      let bundle = R.hostingBundle
      let name = "SettingsViewController"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [NSObject : AnyObject]? = nil) -> UIKit.UIView? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
      }
      
      fileprivate init() {}
    }
    
    struct _TableHeaderView: Rswift.NibResourceType, Rswift.Validatable {
      let bundle = R.hostingBundle
      let name = "TableHeaderView"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [NSObject : AnyObject]? = nil) -> TableHeaderView? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? TableHeaderView
      }
      
      static func validate() throws {
        if UIKit.UIImage(named: "icon_queue", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'icon_queue' is used in nib 'TableHeaderView', but couldn't be loaded.") }
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      try launchScreen.validate()
    }
    
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UIViewController
      
      let bundle = R.hostingBundle
      let name = "LaunchScreen"
      
      static func validate() throws {
        if UIKit.UIImage(named: "logo") == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'logo' is used in storyboard 'LaunchScreen', but couldn't be loaded.") }
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  fileprivate init() {}
}
