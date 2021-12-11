//
//  Depender.swift
//  
//
//  Created by Ostap on 11.12.2021.
//

import Foundation
import Runtime

public protocol Depender {
    mutating func grabDependencies(from container: ModelStore)
}

public extension Depender {
    mutating func grabDependencies(from container: ModelStore) {
        let info = try! typeInfo(of: Self.self)
        
        for property in info.properties {
            if var dependency = try! property.get(from: self) as? AnyDependency {
                if let model = container.model(ofType: dependency.type) {
                    dependency.resolve(with: model)
                    try! property.set(value: dependency, on: &self)
                }
            }
        }
    }
    
    func withDependencies(from container: ModelStore) -> Self {
        var copy = self
        copy.grabDependencies(from: container)
        return copy
    }
}
