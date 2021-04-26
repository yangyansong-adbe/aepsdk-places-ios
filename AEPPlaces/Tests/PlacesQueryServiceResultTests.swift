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

class PlacesQueryServiceResultTests: XCTestCase {
    
    static let JSON_STRING = """
    {
        "regionid": "1234",
        "regionname": "myplace",
        "latitude": 12.34,
        "longitude": 23.45,
        "radius": 500,
        "weight": 25,
        "libraryid": "mylib",
        "useriswithin": false,
        "regionmetadata": {
            "key1": "value1"
        }
    }
    """
    
    static let JSON_STRING_2 = """
    {
        "regionid": "2345",
        "regionname": "yourplace",
        "latitude": 12.34,
        "longitude": 23.45,
        "radius": 500,
        "weight": 25,
        "libraryid": "mylib",
        "useriswithin": false,
        "regionmetadata": {
            "key1": "value1"
        }
    }
    """
    
    // MARK: - Tests
    
    func testConstructorHappy() throws {
        // setup
        let poi1 = try! PointOfInterest(jsonString: PlacesQueryServiceResultTests.JSON_STRING)
        let poi2 = try! PointOfInterest(jsonString: PlacesQueryServiceResultTests.JSON_STRING_2)
        let result = PlacesQueryServiceResult(pois: [poi1, poi2], response: .ok)
        
        // verify
        XCTAssertEqual(PlacesQueryResponseCode.ok, result.response)
        XCTAssertEqual(2, result.pois?.count)
        let resultPoi1 = result.pois?[0]
        let resultPoi2 = result.pois?[1]
        XCTAssertEqual("1234", resultPoi1?.identifier)
        XCTAssertEqual("myplace", resultPoi1?.name)
        XCTAssertEqual("2345", resultPoi2?.identifier)
        XCTAssertEqual("yourplace", resultPoi2?.name)
    }
    
    func testConstructorNoPois() throws {
        // setup
        let result = PlacesQueryServiceResult(response: .ok)
        
        // verify
        XCTAssertEqual(PlacesQueryResponseCode.ok, result.response)
        XCTAssertNil(result.pois)
    }
    
    func testConstructorNoResponse() throws {
        // setup
        let poi1 = try! PointOfInterest(jsonString: PlacesQueryServiceResultTests.JSON_STRING)
        let poi2 = try! PointOfInterest(jsonString: PlacesQueryServiceResultTests.JSON_STRING_2)
        let result = PlacesQueryServiceResult(pois: [poi1, poi2])
        
        // verify
        XCTAssertEqual(PlacesQueryResponseCode.ok, result.response)
        XCTAssertEqual(2, result.pois?.count)
        let resultPoi1 = result.pois?[0]
        let resultPoi2 = result.pois?[1]
        XCTAssertEqual("1234", resultPoi1?.identifier)
        XCTAssertEqual("myplace", resultPoi1?.name)
        XCTAssertEqual("2345", resultPoi2?.identifier)
        XCTAssertEqual("yourplace", resultPoi2?.name)
    }
    
    func testConstructorNoPoisOrResponse() throws {
        // setup
        let result = PlacesQueryServiceResult()
        
        // verify
        XCTAssertEqual(PlacesQueryResponseCode.ok, result.response)
        XCTAssertNil(result.pois)
    }
}
