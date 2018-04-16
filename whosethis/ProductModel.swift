//
//  ProductModel.swift
//  whosethis
//
//  Copyright © 2018 dannyharris. All rights reserved.
//

import Foundation

struct Product {
    
    let owner: String
    let code: String
    let name: String
    var progress: Float
    let available: Bool
    
    init(code: String, owner: String, name: String, progress: Float, available: Bool ) {
        self.owner = owner
        self.code = code
        self.name = name
        self.progress = progress
        self.available = available
    }
    
    var propertyListRepresentation: [String: Any] {
        return ["code": code, "owner": owner, "name": name, "progress": progress, "available": available]
    }
}
