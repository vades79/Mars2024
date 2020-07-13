//
//  JsonObject.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 11.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation
import RealmSwift

protocol JSONCodable {
    static func fromJSONString(_: String) -> JSONCodable?
    func toJSONString() -> String?
}

class JsonObject: Object {
    @objc dynamic var key = ""
    @objc dynamic var json = ""
    @objc dynamic var date = Date()
    
    class func fromForm(_ form: JSONCodable) -> JsonObject {
        let result = JsonObject()
        result.updateWithForm(form)
        return result
    }
    
    func toForm<FormType: JSONCodable>() -> FormType? {
        guard let form = FormType.fromJSONString(self.json) else {
            return nil
        }
        return form as? FormType
    }
    
    func updateWithForm(_ form: JSONCodable) {
        if let jsonString = form.toJSONString() {
            self.json = jsonString
        }
    }
}
