//
//  StorageBase.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 11.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation
import RealmSwift

class StorageBase {
    let queue = DispatchQueue(label: "com.mars2024.realm")
}

extension Object {
    class func truncate(`in` realm: Realm) {
        let allObjects = realm.objects(self)
        try! realm.write {
            realm.delete(allObjects)
        }
    }
}
