//
//  PersonDto.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 11.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation
import ObjectMapper
import FirebaseFirestore

class PersonDto: Mappable {
    var givename: String?
    var familyname: String?
    var birthDate: String?
    var photoUrl: String?
    var id: String?
    
    init(){}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        givename <- map["givename"]
        familyname <- map["familyname"]
        birthDate <- map["birthDate"]
        photoUrl <- map["photoUrl"]
        id <- map["id"]
    }
    
    func toModel() -> Person {
        return Person(
            givename: self.givename ?? "",
            familyname: self.familyname ?? "",
            birthDate: self.birthDate?.toDate(formatterType: .stringTimestamp),
            photoUrl: URL(string: self.photoUrl ?? ""),
            id: self.id
        )
    }
    
    func toModel(id: String) -> Person {
        return Person(
            givename: self.givename ?? "",
            familyname: self.familyname ?? "",
            birthDate: self.birthDate?.toDate(formatterType: .stringTimestamp),
            photoUrl: URL(string: self.photoUrl ?? ""),
            id: id
        )
    }
    
    static func fromModel(_ model: Person) -> PersonDto {
        let dto = PersonDto()
        dto.givename = model.givename
        dto.familyname = model.familyname
        dto.birthDate = model.birthDate?.toString(.stringTimestamp)
        dto.photoUrl = model.photoUrl?.absoluteString
        return dto
    }
}

extension PersonDto: JSONCodable {
    static func fromJSONString(_ string: String) -> JSONCodable? {
        return PersonDto(JSONString: string)
    }
    
    func toJSONString() -> String? {
        self.toJSONString(prettyPrint: false)
    }
}


