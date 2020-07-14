//
//  BaseResponse.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 14.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseResponse: Mappable {
    var errorCode: String?
    var errorTitle: String?
    var errorDescription: String?
    
    init() {
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        errorCode <- map["errorCode"]
        errorTitle <- map["title"]
        errorDescription <- map["detail"]
    }
}
