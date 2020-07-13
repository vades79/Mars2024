//
//  LinksDto.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 13.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation
import ObjectMapper

class LinksDto: Mappable {
    var missionPatch: String?
    var missionPatchSmall: String?
    var flickrImages: [String?]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        missionPatch <- map["mission_patch"]
        missionPatchSmall <- map["mission_patch_small"]
        flickrImages <- map["flickr_images"]
    }
    
    func convertToUrl() -> [URL]? {
        var links = [URL]()
        flickrImages?.forEach({ (link) in
            guard let path = link, let url = URL(string: path) else {
                return
            }
            links.append(url)
        })
        return links
    }
}

extension LinksDto: JSONCodable {
    static func fromJSONString(_ string: String) -> JSONCodable? {
        return PersonDto(JSONString: string)
    }
    
    func toJSONString() -> String? {
        self.toJSONString(prettyPrint: false)
    }
}
