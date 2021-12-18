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
    mutating func resolve(with container: AnyDependencyContainer)
}

@propertyWrapper
public struct Dependency<Value: Model>: AnyDependency {
    private var value: Value?
    
    public var wrappedValue: Value {
        get { value! }
    }
    
    mutating func resolve(with value: Value) {
        self.value = value
    }
    
    mutating func resolve(with container: AnyDependencyContainer) {
        value = container.model(ofType: Value.self)
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
    
    mutating func resolve(with container: AnyDependencyContainer) {
        wrapper.value = container.model(ofType: Value.self)
    }
    
    public init() {}
}
