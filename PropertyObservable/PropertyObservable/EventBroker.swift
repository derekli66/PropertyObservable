//
//  EventBroker.swift
//  Observable
//
//  Created by LEE CHIEN-MING on 2018/8/23.
//

import Foundation
import CoreFoundation

protocol ReceiptHandler: class
{
    func invalidate(identifier: String) -> Bool
}

class EventReceipt {
    private weak var delegate: ReceiptHandler?
    private var identifier: String
    
    init(identifier: String, delegate: ReceiptHandler) {
        self.identifier = identifier
        self.delegate = delegate
    }
    
    open func invalidate()
    {
        guard let result = self.delegate?.invalidate(identifier: self.identifier) else { return }
        if result == false { debugPrint("Event {\(identifier)} could not be found.") }
    }
}

typealias EventAction = (Dictionary<String,Any>)->()
protocol EventBroker
{
    func register(_ action: @escaping EventAction) -> EventReceipt
    func trigger(_ change: Dictionary<String,Any>) -> Void
}

enum EventChangeKeys: String {
    case new = "newValue"
    case old = "oldValue"
    
    var key: String {
        return self.rawValue
    }
}

class Event: ReceiptHandler, EventBroker {
    
    private struct ActionHolder {
        let identifier: String
        let eventAction: EventAction
    }
    
    private var events: Array<ActionHolder> = []
    
    /// The lock property is to ensure the UUID creation from CFUUIDCreateString
    /// can be safely released without any memory issue.
    /// Without lock, the UUID creation inside global queue may cause crash sometimes (pointer being freed was not allocated)
    static private let lock = DispatchQueue(label: "Event.Lock")
    
    func register(_ action: @escaping EventAction) -> EventReceipt
    {
        var id = "1"
        Event.lock.sync {
            if let uuid = CFUUIDCreateString(nil, CFUUIDCreate(nil)) { id = uuid as String }
            else {
                if let actionHolder = events.last {
                    id = actionHolder.identifier + "1"
                }
            }
            events.append(ActionHolder(identifier: id, eventAction: action))
        }
    
        return EventReceipt(identifier: id, delegate: self)
    }
    
    func trigger(_ change: Dictionary<String,Any>) -> Void
    {
        for actionHolder in events {
            actionHolder.eventAction(change)
        }
    }
    
    func invalidate(identifier: String) -> Bool
    {
        var success: Bool = false
        
        events = events.filter({ (eventHolder) -> Bool in
            if (eventHolder.identifier == identifier) {
                success = true
            }
            return eventHolder.identifier != identifier
        })
        
        return success
    }
}
