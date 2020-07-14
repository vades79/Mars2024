//
//  LaunchDto.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 13.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation
import ObjectMapper

class LaunchDto: Mappable {
    var flightNumber: Int?
    var missionName: String?
    var details: String?
    var date: String?
    var images: [String]?
    var links: LinksDto?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        flightNumber <- map["flight_number"]
        missionName <- map["mission_name"]
        details <- map["details"]
        date <- map["launch_year"]
        links <- map["links"]
    }
    
    func toModel() -> Launch {
        return Launch(flightNumber: flightNumber,
                      missionName: missionName,
                      details: details,
                      date: date,
                      missionPatch: URL(string: links?.missionPatch ?? ""),
                      missionPatchSmall: URL(string: links?.missionPatchSmall ?? ""),
                      images: links?.convertToUrl())
    }
}

extension LaunchDto: JSONCodable {
    static func fromJSONString(_ string: String) -> JSONCodable? {
        return PersonDto(JSONString: string)
    }
    
    func toJSONString() -> String? {
        self.toJSONString(prettyPrint: false)
    }
}
