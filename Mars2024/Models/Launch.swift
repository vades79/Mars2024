//
//  Launch.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 13.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation

class Launch {
    var flightNumber: Int?
    var missionName: String
    var details: String
    var date: String?
    var missionPatch: URL?
    var missionPatchSmall: URL?
    var images: [URL]?
    
    init(flightNumber: Int?, missionName: String?, details: String?, date: String?, missionPatch: URL?, missionPatchSmall: URL?, images: [URL]?) {
        self.flightNumber = flightNumber
        self.missionName = missionName ?? ""
        self.details = details ?? ""
        self.date = date
        self.missionPatch = missionPatch
        self.missionPatchSmall = missionPatchSmall
        self.images = images
    }
}

