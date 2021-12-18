//
//  Depender.swift
//  
//
//  Created by Ostap on 11.12.2021.
//

import Foundation
import Runtime

public protocol Depender {
    mutating func grabDependencies(from container: AnyDependencyContainer)
}

public extension Depender {
    mutating func grabDependencies(from container: AnyDependencyContainer) {
        let info = try! typeInfo(of: Self.self)
        
        for property in info.properties {
            if var dependency = try! property.get(from: self) as? AnyDependency {
                dependency.resolve(with: container)
                try! property.set(value: dependency, on: &self)
            }
        }
    }
    
    func withDependencies(from container: AnyDependencyContainer) -> Self {
        var copy = self
        copy.grabDependencies(from: container)
        return copy
    }
}
