//
//  Database.swift
//  Pods-PVDRealmWrapper_Tests
//
//  Created by Вадим Попов on 10/24/17.
//

import Foundation
import RealmSwift

/**
 *
 *
 */
open class Database {
    
    private static var instance: Database!
    open class var shared: Database {
        get {
            if (instance == nil) {
                instance = Database()
            }
            return instance
        }
    }
    
    private init() {
        self.realm = try! Realm()
    }
    
    ///
    open var realm: Realm!
    
    /**
     */
    open func save(_ object: Object, update: Bool = true, completion: (() -> Void)? = nil) {
        try! realm.write {
            realm.add(object, update: update)
            try! realm.commitWrite()
            completion?()
        }
    }
    
    /**
     */
    open func save(_ objects: [Object], update: Bool = true, completion: (() -> Void)? = nil) {
        try! realm.write {
            realm.add(objects, update: update)
            try! realm.commitWrite()
            completion?()
        }
    }
    
    /**
     * Daprecated, use save(objects: update: completion: )
     * Will be removed in future
     */
    open func batchSave(_ objects: [Object], update: Bool = true) {
        save(objects, update: update)
    }
    
    /**
     */
    open func refreshAll<T: Object>(_ type: T.Type, with objects: [T], completion: (() -> Void)? = nil) throws {
        let objectsToDelete: Results<T> = fetch(type)
        try realm.write {
            realm.delete(objectsToDelete)
            realm.add(objects, update: false)
            try realm.commitWrite()
            completion?()
        }
    }
    
    /**
     */
    private func fetch<T: Object>(_ type: T.Type, filter: String? = nil, sort: SortDescriptor? = nil) -> Results<T> {
        var results = realm.objects(type)
        if let filter = filter {
            results = results.filter(filter)
        }
        if let sort = sort {
            results = results.sorted(byKeyPath: sort.keyPath, ascending: sort.ascending)
        }
        return results
    }
    
    /**
     */
    open func fetch<T: Object>(_ type: T.Type, filter: String? = nil, sort: SortDescriptor? = nil) -> Array<T> {
        let results: Results<T> = fetch(type, filter: filter, sort: sort)
        return Array(results)
    }
    
    /**
     */
    open func fetchFirst<T: Object>(_ type: T.Type, filter: String? = nil, sort: SortDescriptor? = nil) -> T? {
        return fetch(type, filter: filter, sort: sort).first
    }
    
    /**
     */
    open func delete(_ object: Object) {
        try! realm.write {
            realm.delete(object)
        }
    }
    
    /**
     */
    open func delete(_ objects: [Object]) {
        try! realm.write {
            realm.delete(objects)
        }
    }
    
    /**
     */
    open func deleteAll<T: Object>(_ type: T.Type) {
        let objects: Results<T> = fetch(type)
        try! realm.write {
            realm.delete(objects)
        }
    }
    
    /**
     */
    open func deleteAll() {
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    /**
     */
    open func copy<T: Object> (_ object: T, completion: (T) -> Void) {
        try! realm.write {
            completion(realm.create(T.self, value: object))
        }
    }
    
    /**
     */
    open func write(block: () -> Void, completion: (() -> Void)? = nil) throws {
        try realm.write {
            block()
            try realm.commitWrite()
            completion?()
        }
    }
}
