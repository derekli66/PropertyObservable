//
//  main.swift
//  Observable
//
//  Created by LEE CHIEN-MING on 2018/8/22.
//

import Foundation

debugPrint("//-------Event Sample Code------------")
let event = Event()
var receipt: EventReceipt?
DispatchQueue.global().async {
    receipt = event.register { (change) in
        if let value = change[EventChangeKeys.new.key] as? Int {
            debugPrint("Event1 new value: \(value)")
        }
    }
}

var receipt2: EventReceipt?
receipt2 = event.register { (change) in
    if let value = change[EventChangeKeys.new.key] as? Int {
        debugPrint("Event2 value: \(value)")
    }
}

var receipt3: EventReceipt?
receipt3 = event.register { (change) in
    if let value = change[EventChangeKeys.new.key] as? Int {
        debugPrint("Event3 value: \(value)")
    }
}


debugPrint("[Trigger event 404]")
event.trigger([EventChangeKeys.new.key: 404])
receipt?.invalidate()
debugPrint("//-------------------")

debugPrint("[Trigger event 505]")
event.trigger([EventChangeKeys.new.key: 500])
receipt2?.invalidate()
receipt3?.invalidate()
debugPrint("//-------------------")


debugPrint("[Trigger event 200]")
event.trigger([EventChangeKeys.new.key: 200])

print("\n\n")

debugPrint("//-------Property Sample Code------------")
let property = Property<Int>(300)
let receipty = property.observe { (new, old) in
    debugPrint("Property got change with new value: \(new)")
    debugPrint("Property changed and the old value: \(old)")
}
property.set(1001)
receipty.invalidate()
property <<< 301
debugPrint("Property value: \(property.get())")
let v = <<<property
debugPrint(" v is \(v)")

struct BOB {
    let age: Property<Int> = Property<Int>(0)
}

let bob = BOB()
bob.age <<< 30
let observerReceipt = bob.age.observe { (new, old) in
    print("Bob's is getting old on his new age \(new). He was \(old) last year")
}
bob.age <<< 31
print("bob's new age: \(<<<bob.age)")
observerReceipt.invalidate()
