//
//  Model.swift
//  
//
//  Created by Ostap on 05.12.2021.
//

import Foundation
import Combine

func debugFailure<T>(_ closure: @autoclosure () throws -> (T), message: String) throws -> T {
    do {
        return try closure()
    } catch {
        print(message)
        throw error
    }
}

public protocol Model: AnyObject, Depender {
    init()
}

public protocol AnyStoredModel: Model {
    static func load() throws -> AnyStoredModel
    func save() throws
}

public protocol StoredModel: AnyStoredModel {
    static func load() throws -> Self
}

public extension StoredModel {
    static func load() throws -> AnyStoredModel {
        return try load()
    }
}

public protocol CodableModel: StoredModel, Codable {
    static var url: URL { get }
    static func decode(from data: Data) throws -> Self
    func encoded() throws -> Data
}

public extension CodableModel {
    static func load() throws -> Self {
        let data = try debugFailure(Data(contentsOf: url), message: "Can`t load data for \(Self.self)")
        return try debugFailure(decode(from: data), message: "Can`t decode saved data for \(Self.self)")
    }
    
    func save() throws {
        let data = try debugFailure(encoded(), message: "Can`t encode \(Self.self)")
        try debugFailure(data.write(to: Self.url), message: "Can`t save data for \(Self.self)")
    }
}

public protocol JSONModel: CodableModel {}

public extension JSONModel {
    static func decode(from data: Data) throws -> Self {
        try JSONDecoder().decode(Self.self, from: data)
    }
    
    func encoded() throws -> Data {
        try JSONEncoder().encode(self)
    }
}
