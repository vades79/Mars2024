//
//  DeepLinkProcessor.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 09.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation

class DeepLinkProcessor {
    
    static let `default` = DeepLinkProcessor()
    
    var handler: DeepLinkHandler?
    
    var isLocked: Bool {
        clearLocks()
        for lock in locks {
            guard lock.value == nil || lock.value?.isLock == false else {
                return true
            }
        }
        return false
    }
    
    private var locks: [WeakRef<Lock>] = []
    
    private init() {}
    
    func setHandler(_ handler: DeepLinkHandler) {
        self.handler = handler
    }
    
    func lock() -> Lock {
        let lock = Lock()
        clearLocks()
        self.locks.append(WeakRef(lock))
        return lock
    }
    
    private func clearLocks() {
        self.locks = self.locks.filter {
            $0.value != nil
        }
    }
}
