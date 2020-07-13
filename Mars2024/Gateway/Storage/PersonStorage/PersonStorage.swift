//
//  PersonStorage.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 11.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation

protocol PersonStorage {
    func write(_ person: Person)
    func read() -> Person?
    func clear()
}

class PersonStorageImpl: JsonStorage, PersonStorage {
    
    let savedKey = "Person"
    
    func write(_ person: Person) {
        saveJsonDto(PersonDto.fromModel(person), storageKey: savedKey)
    }
    
    func read() -> Person? {
        let dto: PersonDto? = getJsonDto(storageKey: savedKey)
        return dto?.toModel()
    }
    
    func clear() {
        truncateJson()
    }
}
