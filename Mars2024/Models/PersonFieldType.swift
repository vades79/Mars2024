//
//  PersonFieldType.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 12.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation

enum PersonFieldType: CaseIterable {
    case givename
    case familyname
    case birthDate
    
    func isRequired() -> Bool {
        switch self {
        case .givename:
            return true
        case .familyname:
            return true
        case .birthDate:
            return false
        }
    }
    
    var description: String {
        switch self {
        case .givename:
            return R.string.localizable.registrationFieldTitleGivename()
        case .familyname:
            return R.string.localizable.registrationFieldTitleFamilyname()
        case .birthDate:
            return R.string.localizable.registrationFieldTitleAge()
        }
    }
    
    var next: PersonFieldType? {
        switch self {
        case .givename: return .familyname
        case .familyname: return .birthDate
        case .birthDate: return nil
        }
    }
    
    static func by(tag: Int) -> PersonFieldType? {
        switch tag {
        case 1000 + 1:
            return .givename
        case 1000 + 2:
            return .familyname
        case 1000 + 3:
            return .birthDate
        default:
            return nil
        }
    }
    
    var tag: Int {
        switch self {
        case .givename:
            return 1000 + 1
        case .familyname:
            return 1000 + 2
        case .birthDate:
            return 1000 + 3
        }
    }
    
    static func from(_ model: Person) -> [PersonFieldType: String] {
        var values = [PersonFieldType: String]()
        values[.givename] = model.givename
        values[.familyname] = model.familyname
        if let birthDate = model.birthDate {
            values[.birthDate] = birthDate.toString()
        }
        return values
    }
}
