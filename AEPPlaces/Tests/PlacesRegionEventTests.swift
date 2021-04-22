/*
 Copyright 2021 Adobe. All rights reserved.
 This file is licensed to you under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License. You may obtain a copy
 of the License at http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software distributed under
 the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
 OF ANY KIND, either express or implied. See the License for the specific language
 governing permissions and limitations under the License.
 */

import XCTest
@testable import AEPPlaces

class PlacesRegionEventTests: XCTestCase {
   
    // MARK: - Tests
    
    func testConstructorRawValuesEntry() throws {
        // setup
        let entryEvent = PlacesRegionEvent(rawValue: "entry")
        
        // verify
        XCTAssertEqual("entry", entryEvent?.rawValue)
    }
    
    func testConstructorRawValuesExit() throws {
        // setup
        let exitEvent = PlacesRegionEvent(rawValue: "exit")
        
        // verify
        XCTAssertEqual("exit", exitEvent?.rawValue)
    }
    
    func testConstructorRawValuesNone() throws {
        // setup
        let noneEvent = PlacesRegionEvent(rawValue: "none")
        
        // verify
        XCTAssertEqual("none", noneEvent?.rawValue)
    }
    
    func testConstructorRawValuesInvalid() throws {
        // setup
        let unmatchedEvent = PlacesRegionEvent(rawValue: "i don't match anything")
        
        // verify
        XCTAssertNil(unmatchedEvent)
    }
    
    func testFromStringEntry() throws {
        // setup
        let entry = PlacesRegionEvent.fromString("entry")
        
        // verify
        XCTAssertEqual(PlacesRegionEvent.entry, entry)
    }
    
    func testFromStringExit() throws {
        // setup
        let exit = PlacesRegionEvent.fromString("exit")
        
        // verify
        XCTAssertEqual(PlacesRegionEvent.exit, exit)
    }
    
    func testFromStringNone() throws {
        // setup
        let none = PlacesRegionEvent.fromString("none")
        
        // verify
        XCTAssertEqual(PlacesRegionEvent.none, none)
    }
    
    func testFromStringInvalid() throws {
        // setup
        let invalid = PlacesRegionEvent.fromString("i don't match anything")
        
        // verify
        XCTAssertEqual(PlacesRegionEvent.none, invalid)
    }
        
    func testStringValues() throws {
        // verify
        XCTAssertEqual("entry", PlacesRegionEvent.entry.rawValue)
        XCTAssertEqual("exit", PlacesRegionEvent.exit.rawValue)
        XCTAssertEqual("none", PlacesRegionEvent.none.rawValue)
    }
}
