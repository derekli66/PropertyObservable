//
//  PropertyObservable.swift
//  Observable
//
//  Created by LEE CHIEN-MING on 2018/8/24.
//

import Foundation

infix operator <<<
/// infix operator for Property<T> class
/// property <<< T is equivalent to property.set(T)
///
/// - Parameters:
///   - left: Property<T> variable
///   - right: T value
func <<<<T>(left:Property<T>, right:T)
{
    left.set(right)
}

prefix operator <<<
/// prefix operator for Property<T> class
/// <<<property is equivalent to property.get()
///
/// - Parameter property: Property<T> variable
/// - Returns: The value inside Property<T> variable
prefix func <<<<T>(property: Property<T>) -> T
{
    return property.get()
}

typealias ObserverAction<T> = (_ new: T, _ old: T)->()
typealias ObserverReceipt = EventReceipt

class Property<T>
{
    init(_ value: T) {
        self.value = value
    }
    
    private let event: Event = Event()
    
    private var value: T
    {
        didSet{
            event.trigger([EventChangeKeys.new.key: value, EventChangeKeys.old.key: oldValue])
        }
    }
    
    /// Method to register observation action
    /// Please be aware that the ObserverReceipt instance must be kept when leaving
    /// your working scope, otherwise, ObserverReceipt will call invalidate() at deinit
    /// - Parameter change: ObserverAction closure
    /// - Returns: ObserverReceipt instance
    open func observe(_ change: @escaping ObserverAction<T>) -> ObserverReceipt
    {
        let action: EventAction = { (changeMap) in
            if let newValue = changeMap[EventChangeKeys.new.key] as? T,
               let oldValue = changeMap[EventChangeKeys.old.key] as? T {
                    change(newValue, oldValue)
            }
        }
        
        return event.register(action)
    }
    
    open func set(_ value: T)
    {
        self.value = value
    }
    
    open func get() -> T
    {
        return self.value
    }
}
