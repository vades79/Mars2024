//
//  Person.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 11.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import UIKit

class Person {
    var givename: String
    var familyname: String
    var birthDate: Date?
    var photoUrl: URL?
    var photo: UIImage?
    var id: String?
    
    var isMinFill: Bool {
        guard !givename.isEmpty, !familyname.isEmpty else {
            return false
        }
        return true
    }
    
    init() {
        givename = ""
        familyname = ""
    }
    
    init(givename: String, familyname: String, birthDate: Date?, photo: UIImage? = nil, photoUrl: URL? = nil, id: String?) {
        self.givename = givename
        self.familyname = familyname
        self.birthDate = birthDate
        self.photoUrl = photoUrl
        self.photo = photo
        self.id = id
    }
}
