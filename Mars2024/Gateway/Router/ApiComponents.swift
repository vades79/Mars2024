//
//  ApiComponents.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 13.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation
import Alamofire

struct ApiComponents {
    var url: String
    var method: HTTPMethod
    var encoding: ParameterEncoding
    var data: [String: Any]?
    var headers: [String: String]?
    var multipertItems: [MultipartItem]?
}
