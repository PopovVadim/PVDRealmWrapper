//
//  RealmExtras.swift
//  Pods-PVDRealmWrapper_Tests
//
//  Created by Вадим Попов on 10/24/17.
//

import Foundation
import RealmSwift

/**
 */
public func listToArray<T> (_ list: List<T>) -> [T] {
    return Array(list)
}

/**
 */
public func arrayToList<T> (_ array: [T]) -> List<T> {
    let list = List<T>()
    for element in array {
        list.append(element)
    }
    return list
}

/**
 *
 *
 */
open class IntObject: Object {
    open var value = RealmOptional<Int>()
    
    open func makeCopy() -> IntObject {
        let copy = IntObject()
        copy.value = RealmOptional<Int>(self.value.value)
        return copy
    }
}
