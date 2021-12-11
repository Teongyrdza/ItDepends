//
//  Dependency.swift
//  
//
//  Created by Ostap on 11.12.2021.
//

import Foundation

protocol AnyDependency {
    var type: Model.Type { get }
    mutating func resolve(with model: Model)
}

@propertyWrapper
public struct Dependency<Value: Model>: AnyDependency {
    private var value: Value?
    
    public var wrappedValue: Value {
        get { value! }
    }
    
    var type: Model.Type { Value.self }
    
    mutating func resolve(with model: Model) {
        value = model as! Value
    }
    
    public init() {}
}
