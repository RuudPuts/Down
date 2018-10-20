//
//  DownloadItemDetailRow.swift
//  Down
//
//  Created by Ruud Puts on 20/10/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

struct DownloadItemDetailRow {
    let key: DownloadItemDetailRow.Key
    let value: String

    var title: String {
        switch key {
        case .nzbname: return "NZB"
        case .status: return "Status"
        case .progress: return "Progress"
        case .totalSize: return "Total download size"

        case .sizeLeft: return "Remaining"
        case .timeLeft: return "Time remaining"

        case .completedTime: return "Finished on"
        case .postProcessingOutput: return "Post processing"

        case .showName: return "Show"
        case .episodeNumber: return "Episode"
        case .episodeName: return "Title"
        case .episodeAirdate: return "Aired on"
        case .episodePlot: return "Plot"
        }
    }

    var type: DownloadItemDetailRow.RowType {
        switch key {
        case .postProcessingOutput, .episodePlot:
            return .largeText
        default:
            return .keyValue
        }
    }
}

extension DownloadItemDetailRow {
    enum Key {
        case nzbname
        case status
        case progress
        case totalSize

        // Queue specific
        case sizeLeft
        case timeLeft

        // History specific
        case completedTime
        case postProcessingOutput

        // Dvr
        case showName
        case episodeNumber
        case episodeName
        case episodeAirdate
        case episodePlot
    }

    enum RowType {
        case keyValue
        case largeText
    }
}
