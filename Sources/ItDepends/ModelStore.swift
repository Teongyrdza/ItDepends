//
//  ModelStore.swift
//  
//
//  Created by Ostap on 11.12.2021.
//

import Foundation
import Combine

public final class ModelStore: AnyDependencyContainer, ObservableObject {
    private var models = [ObjectIdentifier : Model]()
    
    public func model<T: Model>(ofType type: T.Type) -> T? {
        if type == Self.self {
            return self as? T
        }
        
        return models[ObjectIdentifier(type)] as? T
    }
    
    public func save() {
        for model in models.values {
            if let storedModel = model as? AnyStoredModel {
                try? storedModel.save()
            }
        }
    }
    
    public init() {}
    
    public init(_ types: Model.Type...) {
        for type in types {
            if let storedModelType = type as? AnyStoredModel.Type, let model = try? storedModelType.load() {
                models[ObjectIdentifier(type)] = model
                continue
            }
            
            models[ObjectIdentifier(type)] = type.init()
        }
        
        for model in models.values {
            var copy = model
            copy.grabDependencies(from: self)
        }
    }
}
