//
//  WeakRef.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 09.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation

class WeakRef<T> where T: AnyObject {
    private(set) weak var value: T?

    init(_ value: T?) {
        self.value = value
    }
}
