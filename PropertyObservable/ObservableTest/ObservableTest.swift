//
//  ObservableTest.swift
//  ObservableTest
//
//  Created by LEE CHIEN-MING on 2018/8/24.
//

import XCTest

class ObservableTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEventBroker()
    {
        let event = Event()
        
        var check: Bool = false
        let receipt = event.register { (changeMap) in
            if let newValue = changeMap[EventChangeKeys.new.key] as? Int {
                XCTAssert(newValue == 200, "newValue must equal to 200")
            }
            else {
                XCTAssert(false)
            }
            if let oldValue = changeMap[EventChangeKeys.old.key] as? Int {
                XCTAssert(oldValue == 300, "oldValue must equal to 300")
            }
            else {
                XCTAssert(false)
            }
            
            check = !check
        }
        event.trigger([EventChangeKeys.new.key: 200, EventChangeKeys.old.key: 300])
        XCTAssert(check == true, "Event got successfully triggered")
        receipt.invalidate()
        event.trigger([EventChangeKeys.new.key: 200, EventChangeKeys.old.key: 300])
        XCTAssert(check == true, "Event should not be triggered twice")
    }
    
    func testEventBrokerAutoInvalidate()
    {
        let event = Event()
        
        var check: Bool = false
        _ = event.register { (changeMap) in
            check = !check
        }
        
        event.trigger([EventChangeKeys.new.key: 200, EventChangeKeys.old.key: 300])
        XCTAssert(check == false, "Event should not get triggered")
    }
    
    func testProperty()
    {
        let property = Property<Int>(0)
        let receipty = property.observe { (new, old) in
            XCTAssert(new == 1001, "newValue must equal to 1001")
            XCTAssert(old == 0, "oldValue must equal to 0")
        }
        property.set(1001)
        receipty.invalidate()
        
        var check: Bool = false
        let receipty2 = property.observe { (new, old) in
            XCTAssert(new == 404, "newValue must equal to 404")
            XCTAssert(old == 1001, "oldValue must equal to 1001")
            check = !check
        }
        property <<< 404
        var finalValue1: Int = 0
        finalValue1 <<< property
        let finalValue2 = property.get()
        XCTAssert(finalValue1 == finalValue2, "getter and prefix operator should return the same value")
        receipty2.invalidate()
        
        property <<< 99
        XCTAssert(check == true, "Property chagne event should not be triggered twice")
        XCTAssert(99 == property.get(), "Property value must be the same after setter")
    }
    
}
