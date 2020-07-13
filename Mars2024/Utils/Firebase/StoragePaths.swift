//
//  StoragePath.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 12.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation
import FirebaseStorage

extension Storage {
    
    func userImagesPathJPEG(id: String) -> StorageReference {
        self.reference().child("image").child("userImages").child(id + ".jpeg")
    }
}
