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

import CoreLocation
import XCTest
@testable import AEPPlaces

class CLAuthorizationStatusPlusPlacesTests: XCTestCase {
    // MARK: - Tests
    func testToStringAllowAlways() throws {
        XCTAssertEqual("always", CLAuthorizationStatus.authorizedAlways.stringValue)
    }
    
    func testToStringAllowWhenInUse() throws {
        XCTAssertEqual("wheninuse", CLAuthorizationStatus.authorizedWhenInUse.stringValue)
    }
    
    func testToStringDenied() throws {
        XCTAssertEqual("denied", CLAuthorizationStatus.denied.stringValue)
    }
    
    func testToStringRestricted() throws {
        XCTAssertEqual("restricted", CLAuthorizationStatus.restricted.stringValue)
    }
    
    func testToStringUnknown() throws {
        XCTAssertEqual("unknown", CLAuthorizationStatus.notDetermined.stringValue)
    }
        
    func testFromStringAlways() throws {
        XCTAssertEqual(.authorizedAlways, CLAuthorizationStatus(fromString: "always"))
    }
    
    func testFromStringWhenInUse() throws {
        XCTAssertEqual(.authorizedWhenInUse, CLAuthorizationStatus(fromString: "wheninuse"))
    }
    
    func testFromStringDenied() throws {
        XCTAssertEqual(.denied, CLAuthorizationStatus(fromString: "denied"))
    }
    
    func testFromStringRestricted() throws {
        XCTAssertEqual(.restricted, CLAuthorizationStatus(fromString: "restricted"))
    }
    
    func testFromStringUnknown() throws {
        XCTAssertEqual(.notDetermined, CLAuthorizationStatus(fromString: "unknown"))
    }
    
    func testFromStringInvalid() throws {
        XCTAssertEqual(.notDetermined, CLAuthorizationStatus(fromString: "blah"))
    }
}
