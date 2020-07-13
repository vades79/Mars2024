//
//  Lock.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 09.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation

class Lock {
    private(set) var isLock: Bool = true
    
    func unlock() {
        isLock = false
    }
    
    func lock() {
        isLock = true
    }
}
