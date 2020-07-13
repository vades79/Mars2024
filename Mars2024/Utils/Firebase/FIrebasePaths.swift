//
//  FIrebasePaths.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 11.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation
import FirebaseFirestore

extension Firestore {
    
    func personCollection() -> CollectionReference {
        return self.collection("persons")
    }
}
