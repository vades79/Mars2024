//
//  JsonStorage.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 11.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation
import RealmSwift

class JsonStorage: StorageBase {
    func saveJsonDto<DtoType: JSONCodable>(_ form: DtoType, storageKey: String) {
        let realm = try! Realm()
        let result = realm.objects(JsonObject.self).filter({
            $0.key == storageKey
        }).first
        
        try! realm.write({
            if let result = result {
                result.updateWithForm(form)
            } else {
                let object = JsonObject.fromForm(form)
                object.key = storageKey
                realm.add(object)
            }
        })
    }
    
    func getJsonDto<DtoType: JSONCodable>(storageKey: String) -> DtoType? {
        let realm = try! Realm()
        let form = realm.objects(JsonObject.self).filter({
            $0.key == storageKey
        }).first
        let result: DtoType? = form?.toForm()
        return result
    }
    
    func removeJson(storageKey: String) {
        let realm = try! Realm()
        guard let form = realm.objects(JsonObject.self).filter({
            $0.key == storageKey
        }).first else {
            return
        }
        try! realm.write({
            realm.delete(form)
        })
    }
    
    func truncateJson() {
        let realm = try! Realm()
        JsonObject.truncate(in: realm)
    }
}
