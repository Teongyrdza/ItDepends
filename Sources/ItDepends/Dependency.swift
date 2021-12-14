//
//  Dependency.swift
//  
//
//  Created by Ostap on 11.12.2021.
//

import Foundation
import SwiftUI
import Combine

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
        value = (model as! Value)
    }
    
    public init() {}
}

@propertyWrapper
public struct ObservedDependency<Value: Model & ObservableObject>: AnyDependency, DynamicProperty {
    @ObservedObject private var wrapper = Wrapper()
    
    class Wrapper: ObservableObject {
        private var cancellables = Set<AnyCancellable>()
        
        var value: Value? {
            didSet {
                if let value = value {
                    value.objectWillChange
                        .sink { _ in
                            self.objectWillChange.send()
                        }
                        .store(in: &cancellables)
                }
            }
        }
    }
    
    public var wrappedValue: Value {
        wrapper.value!
    }
    
    public var projectedValue: Binding<Value> {
        Binding(get: { wrapper.value! }, set: { _ in })
    }
    
    var type: Model.Type { Value.self }
    
    mutating func resolve(with model: Model) {
        wrapper.value = (model as! Value)
    }
    
    public init() {}
}
