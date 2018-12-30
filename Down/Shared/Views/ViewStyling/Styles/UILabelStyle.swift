//
//  UILabelStyle.swift
//  Down
//
//  Created by Ruud Puts on 14/08/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

import UIKit
import DownKit

extension ViewStyling where ViewType == UILabel {
    static var headerLabel = ViewStyling {
        $0.textColor = Stylesheet.Colors.white
        $0.font = Stylesheet.Fonts.headerFont
    }
    static var largeHeaderLabel = ViewStyling {
        $0.style(as: .headerLabel)
        $0.font = Stylesheet.Fonts.largeHeaderFont
    }

    static var titleLabel = ViewStyling {
        $0.textColor = Stylesheet.Colors.white
        $0.font = Stylesheet.Fonts.titleFont
    }

    static var boldTitleLabel = ViewStyling {
        $0.style(as: .titleLabel)
        $0.font = Stylesheet.Fonts.boldTitleFont
    }

    static var detailLabel = ViewStyling {
        $0.textColor = Stylesheet.Colors.white
        $0.font = Stylesheet.Fonts.detailFont
    }

    static var boldDetailLabel = ViewStyling {
        $0.style(as: .detailLabel)
        $0.font = Stylesheet.Fonts.boldDetailFont
    }

    static var greenDetailLabel = ViewStyling {
        $0.style(as: .boldDetailLabel)
        $0.textColor = Stylesheet.Colors.green
    }

    static var redDetailLabel = ViewStyling {
        $0.style(as: .boldDetailLabel)
        $0.textColor = Stylesheet.Colors.red
    }
}

extension ViewStyling where ViewType == UILabel {
    static var scalingTextLabel = ViewStyling {
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.8
    }
}

extension ViewStyling where ViewType == UILabel {
    static func qualityLabel(_ quality: Quality) -> ViewStyling {
        return ViewStyling {
            $0.style(as: .roundedView($0.bounds.midY))
            $0.style(as: .boldDetailLabel)
            $0.textColor = Stylesheet.Colors.white

            switch quality {
            case .hd1080p, .hd720p:
                $0.backgroundColor = Stylesheet.Colors.green
            case .hdtv:
                $0.backgroundColor = Stylesheet.Colors.orange
            case .any, .unknown:
                $0.backgroundColor = Stylesheet.Colors.blue
            }
        }
    }
}

// MARK: - Download specific

extension ViewStyling where ViewType == UILabel {
    static func queueItemStatusLabel(_ status: DownloadQueueItem.State) -> ViewStyling {
        return ViewStyling {
            switch status {
            case .unknown:
                $0.textColor = Stylesheet.Colors.white
            case .queued:
                $0.textColor = Stylesheet.Colors.blue
            case .grabbing:
                $0.textColor = Stylesheet.Colors.purple
            case .downloading:
                $0.textColor = Stylesheet.Colors.green
            }
        }
    }

    static func historyItemStatusLabel(_ status: DownloadHistoryItem.State) -> ViewStyling {
        return ViewStyling {
            switch status {
            case .unknown:
                $0.textColor = Stylesheet.Colors.white
            case .queued:
                $0.textColor = Stylesheet.Colors.blue
            case .verifying:
                $0.textColor = Stylesheet.Colors.purple
            case .repairing:
                $0.textColor = Stylesheet.Colors.purple
            case .extracting:
                $0.textColor = Stylesheet.Colors.purple
            case .postProcessing:
                $0.textColor = Stylesheet.Colors.orange
            case .failed:
                $0.textColor = Stylesheet.Colors.red
            case .completed:
                $0.textColor = Stylesheet.Colors.green
            }
        }
    }
}

// MARK: - Dvr specific

extension ViewStyling where ViewType == UILabel {
    static func showStatusLabel(_ status: DvrShowStatus) -> ViewStyling {
        return ViewStyling {
            switch status {
            case .continuing:
                $0.textColor = Stylesheet.Colors.green
            case .ended:
                $0.textColor = Stylesheet.Colors.red
            case .unknown:
                $0.textColor = Stylesheet.Colors.white
            }
        }
    }

    static func episodeStatusLabel(_ status: DvrEpisodeStatus) -> ViewStyling {
        return ViewStyling {
            switch status {
            case .wanted:
                $0.textColor = Stylesheet.Colors.red
            case .skipped, .archived, .ignored, .unaired:
                $0.textColor = Stylesheet.Colors.blue
            case .snatched:
                $0.textColor = Stylesheet.Colors.purple
            case .downloaded:
                $0.textColor = Stylesheet.Colors.green
            case .unknown:
                $0.textColor = Stylesheet.Colors.white
            }
        }
    }
}
