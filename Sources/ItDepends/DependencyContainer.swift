//
//  File.swift
//  
//
//  Created by Ostap on 18.12.2021.
//

import Foundation

public protocol AnyDependencyContainer: Model {
    func model<T: Model>(ofType type: T.Type) -> T?
}

public final class DependencyContainer: AnyDependencyContainer {
    private var models = [ObjectIdentifier : Model]()
    
    public func model<T: Model>(ofType type: T.Type) -> T? {
        if type == Self.self {
            return self as? T
        }
        
        return models[ObjectIdentifier(type)] as? T
    }
    
    public init(_ models: Model...) {
        for model in models {
            self.models[ObjectIdentifier(type(of: model))] = model
        }
    }
    
    public init() {}
}
