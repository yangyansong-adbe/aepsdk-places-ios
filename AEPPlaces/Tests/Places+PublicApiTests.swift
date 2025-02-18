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
@testable import AEPCore

class PlacesPlusPublicApiTests: XCTestCase {
    var extensionContainer: ExtensionContainer!
    
    override func setUp() {
        EventHub.shared = EventHub()
        MockExtension.reset()
        EventHub.shared.start()
        registerMockExtension(MockExtension.self)
        extensionContainer = EventHub.shared.getExtensionContainer(MockExtension.self)!
    }
    
    // MARK: - helpers
    
    private func registerMockExtension<T: Extension> (_ type: T.Type) {
        let semaphore = DispatchSemaphore(value: 0)
        EventHub.shared.registerExtension(type) { (error) in
            semaphore.signal()
        }
        
        semaphore.wait()
    }
    
    // MARK: - tests
    
    // MARK: - clear
    func testClear() throws {
        // setup
        let expectation = XCTestExpectation(description: "clear should dispatch an event")         
        extensionContainer.registerListener(type: EventType.places, source: EventSource.requestContent) { (event) in
            XCTAssertEqual(PlacesConstants.EventDataKey.Places.RequestType.RESET,
                           event.data?[PlacesConstants.EventDataKey.Places.REQUEST_TYPE] as? String)
            expectation.fulfill()
        }
        
        // test
        Places.clear()
        
        // verify
        wait(for: [expectation], timeout: 1)
    }
        
    // MARK: - getCurrentPointsOfInterest
    func testGetCurrentPointsOfInterest() throws {
        // setup
        let expectation = XCTestExpectation(description: "getCurrentPointsOfInterest should dispatch an event")
        extensionContainer.registerListener(type: EventType.places, source: EventSource.requestContent) { (event) in
            XCTAssertEqual(PlacesConstants.EventDataKey.Places.RequestType.GET_USER_WITHIN_PLACES,
                           event.data?[PlacesConstants.EventDataKey.Places.REQUEST_TYPE] as? String)
            expectation.fulfill()
        }
        
        // test
        Places.getCurrentPointsOfInterest { _ in }
        
        // verify
        wait(for: [expectation], timeout: 1)
    }
    
    // MARK: - getLastKnownLocation
    func testGetLastKnownLocation() throws {
        // setup
        let expectation = XCTestExpectation(description: "getLastKnownLocation should dispatch an event")
        extensionContainer.registerListener(type: EventType.places, source: EventSource.requestContent) { (event) in
            XCTAssertEqual(PlacesConstants.EventDataKey.Places.RequestType.GET_LAST_KNOWN_LOCATION,
                           event.data?[PlacesConstants.EventDataKey.Places.REQUEST_TYPE] as? String)
            expectation.fulfill()
        }
        
        // test
        Places.getLastKnownLocation { _ in }
        
        // verify
        wait(for: [expectation], timeout: 1)
    }
    
    // MARK: - getNearbyPointsOfInterest
    func testGetNearbyPointsOfInterest() throws {
        // setup
        let expectation = XCTestExpectation(description: "getNearbyPointsOfInterest should dispatch an event")
        extensionContainer.registerListener(type: EventType.places, source: EventSource.requestContent) { (event) in
            XCTAssertEqual(PlacesConstants.EventDataKey.Places.RequestType.GET_NEARBY_PLACES,
                           event.data?[PlacesConstants.EventDataKey.Places.REQUEST_TYPE] as? String)
            XCTAssertEqual(12.34, event.data?[PlacesConstants.EventDataKey.Places.LATITUDE] as? Double)
            XCTAssertEqual(23.45, event.data?[PlacesConstants.EventDataKey.Places.LONGITUDE] as? Double)
            XCTAssertEqual(3, event.data?[PlacesConstants.EventDataKey.Places.COUNT] as? UInt)
            expectation.fulfill()
        }
        let location = CLLocation(latitude: 12.34, longitude: 23.45)
        
        // test
        Places.getNearbyPointsOfInterest(forLocation: location, withLimit: 3) { (_, _) in }
                
        // verify
        wait(for: [expectation], timeout: 1)
    }
    
    // MARK: - processRegionEvent
    func testProcessRegionEvent() throws {
        // setup
        let expectation = XCTestExpectation(description: "processRegionEvent should dispatch an event")
        extensionContainer.registerListener(type: EventType.places, source: EventSource.requestContent) { (event) in
            XCTAssertEqual(PlacesConstants.EventDataKey.Places.RequestType.PROCESS_REGION_EVENT,
                           event.data?[PlacesConstants.EventDataKey.Places.REQUEST_TYPE] as? String)
            XCTAssertEqual("id", event.data?[PlacesConstants.EventDataKey.Places.REGION_ID] as? String)
            XCTAssertEqual("entry", event.data?[PlacesConstants.EventDataKey.Places.REGION_EVENT_TYPE] as? String)
            expectation.fulfill()
        }
        let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 12.34, longitude: 23.45), radius: 100, identifier: "id")
                
        // test
        Places.processRegionEvent(.entry, forRegion: region)
        
        // verify
        wait(for: [expectation], timeout: 1)
    }
    
    // MARK: - setAccuracyAuthorization
    @available(iOS 14, *)
    func testSetAccuracyAuthorization() throws {
        // setup
        let expectation = XCTestExpectation(description: "setAccuracyAuthorization should dispatch an event")
        extensionContainer.registerListener(type: EventType.places, source: EventSource.requestContent) { (event) in
            XCTAssertEqual(PlacesConstants.EventDataKey.Places.RequestType.SET_ACCURACY,
                           event.data?[PlacesConstants.EventDataKey.Places.REQUEST_TYPE] as? String)
            XCTAssertEqual("full", event.data?[PlacesConstants.EventDataKey.Places.ACCURACY] as? String)
            expectation.fulfill()
        }
        
        // test
        Places.setAccuracyAuthorization(accuracy: .fullAccuracy)
        
        // verify
        wait(for: [expectation], timeout: 1)
    }
    
    // MARK: - setAuthorizationStatus    
    func testSetAuthorizationStatus() throws {
        // setup
        let expectation = XCTestExpectation(description: "setAuthorizationStatus should dispatch an event")
        extensionContainer.registerListener(type: EventType.places, source: EventSource.requestContent) { (event) in
            XCTAssertEqual(PlacesConstants.EventDataKey.Places.RequestType.SET_AUTHORIZATION_STATUS,
                           event.data?[PlacesConstants.EventDataKey.Places.REQUEST_TYPE] as? String)
            XCTAssertEqual("always", event.data?[PlacesConstants.EventDataKey.Places.AUTH_STATUS] as? String)            
            expectation.fulfill()
        }
                
        // test
        Places.setAuthorizationStatus(status: .authorizedAlways)
        
        // verify
        wait(for: [expectation], timeout: 1)
    }
}
