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
import AEPCore

class EventPlusPlacesTests: XCTestCase {

    // MARK: - Helpers
    
    func getNearbyPlacesRequestEvent(type: String = EventType.places,
                                     source: String = EventSource.requestContent,
                                     requestType: String = PlacesConstants.EventDataKey.Places.RequestType.GET_NEARBY_PLACES,
                                     latitude: Double = 12.34,
                                     longitude: Double = 23.45,
                                     count: Int = 5) -> Event {
        return Event(name: "name", type: type, source: source, data: [
            PlacesConstants.EventDataKey.Places.REQUEST_TYPE: requestType,
            PlacesConstants.EventDataKey.Places.LATITUDE: latitude,
            PlacesConstants.EventDataKey.Places.LONGITUDE: longitude,
            PlacesConstants.EventDataKey.Places.COUNT: count,
        ])
    }
    
    func getSharedStateUpdateEvent(type: String = EventType.hub,
                                   source: String = EventSource.sharedState,
                                   stateOwner: String = PlacesConstants.EventDataKey.Configuration.SHARED_STATE_NAME) -> Event {
        return Event(name: "name", type: type, source: source, data: [
            PlacesConstants.EventDataKey.SHARED_STATE_OWNER: stateOwner
        ])
    }
    
    func getGenericEventWithData(_ data: [String: Any]) -> Event {
        return Event(name: "name", type: EventType.analytics, source: EventSource.requestContent, data: data)
    }

    
    // MARK: - Tests
    func testIsPlacesRequestEventTrue() throws {
        // setup
        let event = getNearbyPlacesRequestEvent()
        
        // verify
        XCTAssertTrue(event.isPlacesRequestEvent)
    }
    
    func testIsPlacesRequestEventFalse() throws {
        // setup
        let event1 = Event(name: "name", type: EventType.places, source: EventSource.os, data: nil)
        let event2 = Event(name: "name", type: EventType.hub, source: EventSource.requestContent, data: nil)
        
        // verify
        XCTAssertFalse(event1.isPlacesRequestEvent, "Should be false when EventSource is not 'requestContent'")
        XCTAssertFalse(event2.isPlacesRequestEvent, "Should be false when EventType is not 'places'")
    }
    
    func testIsSharedStateUpdateEventTrue() throws {
        // setup
        let event = getSharedStateUpdateEvent()
        
        // verify
        XCTAssertTrue(event.isSharedStateUpdateEvent)
    }
    
    func testIsSharedStateUpdateEventFalse() throws {
        // setup
        let event1 = Event(name: "name", type: EventType.hub, source: EventSource.os, data: nil)
        let event2 = Event(name: "name", type: EventType.analytics, source: EventSource.sharedState, data: nil)
        
        // verify
        XCTAssertFalse(event1.isPlacesRequestEvent, "Should be false when EventSource is not 'sharedState'")
        XCTAssertFalse(event2.isPlacesRequestEvent, "Should be false when EventType is not 'hub'")
    }
    
    func testSharedStateOwnerHappy() throws {
        // setup
        let event = getSharedStateUpdateEvent()
        
        // verify
        XCTAssertEqual(PlacesConstants.EventDataKey.Configuration.SHARED_STATE_NAME, event.sharedStateOwner!)
    }
    
    func testSharedStateOwnerEmpty() throws {
        // setup
        let event = getNearbyPlacesRequestEvent()
        
        // verify
        XCTAssertNil(event.sharedStateOwner)
    }
    
    func testPrivacyStatusHappy() throws {
        // setup
        let event = getGenericEventWithData([PlacesConstants.EventDataKey.Configuration.GLOBAL_CONFIG_PRIVACY: "optedin"])
        
        // verify
        XCTAssertNotNil(event.privacyStatus)
        XCTAssertEqual("optedin", event.privacyStatus!)
    }
    
    func testPrivacyStatusEmpty() throws {
        // setup
        let event = getGenericEventWithData([:])
        
        // verify
        XCTAssertNil(event.privacyStatus)
    }
    
    func testLocationAuthorizationStatusHappy() throws {
        // setup
        let event = getGenericEventWithData([PlacesConstants.EventDataKey.Places.AUTH_STATUS: "always"])
        
        // verify
        XCTAssertNotNil(event.locationAuthorizationStatus)
        XCTAssertEqual("always", event.locationAuthorizationStatus!)
    }
    
    func testLocationAuthorizationStatusEmpty() throws {
        // setup
        let event = getGenericEventWithData([:])
        
        // verify
        XCTAssertNil(event.locationAuthorizationStatus)
    }
    
    func testPlacesRequestTypeHappy() throws {
        // setup
        let event = getNearbyPlacesRequestEvent()
        
        // verify
        XCTAssertNotNil(event.placesRequestType)
        XCTAssertEqual(PlacesConstants.EventDataKey.Places.RequestType.GET_NEARBY_PLACES, event.placesRequestType!)
    }
    
    func testPlacesRequestTypeEmpty() throws {
        // setup
        let event = getSharedStateUpdateEvent()
        
        // verify
        XCTAssertNil(event.placesRequestType)
    }
    
    func testLatitudeHappy() throws {
        // setup
        let event = getNearbyPlacesRequestEvent()
        
        // verify
        XCTAssertNotNil(event.latitude)
        XCTAssertEqual(12.34, event.latitude!)
    }
    
    func testLatitudeEmpty() throws {
        // setup
        let event = getSharedStateUpdateEvent()
        
        // verify
        XCTAssertNil(event.latitude)
    }
    
    func testLongitudeHappy() throws {
        // setup
        let event = getNearbyPlacesRequestEvent()
        
        // verify
        XCTAssertNotNil(event.longitude)
        XCTAssertEqual(23.45, event.longitude!)
    }
    
    func testLongitudeEmpty() throws {
        // setup
        let event = getSharedStateUpdateEvent()
        
        // verify
        XCTAssertNil(event.longitude)
    }
    
    func testRequestedPoiCountHappy() throws {
        // setup
        let event = getNearbyPlacesRequestEvent()
        
        // verify
        XCTAssertNotNil(event.requestedPoiCount)
        XCTAssertEqual(5, event.requestedPoiCount!)
    }
    
    func testRequestedPoiCountEmpty() throws {
        // setup
        let event = getSharedStateUpdateEvent()
        
        // verify
        XCTAssertNil(event.requestedPoiCount)
    }
    
    func testPlacesQueryResponseCodeHappy() throws {
        // setup
        let event = getGenericEventWithData([PlacesConstants.EventDataKey.Places.RESPONSE_STATUS: 0])
        
        // verify
        XCTAssertNotNil(event.placesQueryResponseCode)
        XCTAssertEqual(PlacesQueryResponseCode.ok, event.placesQueryResponseCode!)
    }
    
    func testPlacesQueryResponseCodeEmpty() throws {
        // setup
        let event = getSharedStateUpdateEvent()
        
        // verify
        XCTAssertNil(event.placesQueryResponseCode)
    }
    
    func testRegionIdHappy() throws {
        // setup
        let event = getGenericEventWithData([PlacesConstants.EventDataKey.Places.REGION_ID: "552"])
        
        // verify
        XCTAssertNotNil(event.regionId)
        XCTAssertEqual("552", event.regionId!)
    }
    
    func testRegionIdEmpty() throws {
        // setup
        let event = getSharedStateUpdateEvent()
        
        // verify
        XCTAssertNil(event.regionId)
    }
    
    func testRegionEventTypeHappy() throws {
        // setup
        let event = getGenericEventWithData([PlacesConstants.EventDataKey.Places.REGION_EVENT_TYPE: "entry"])
        
        // verify
        XCTAssertNotNil(event.regionEventType)
        XCTAssertEqual("entry", event.regionEventType!)
    }
    
    func testRegionEventTypeEmpty() throws {
        // setup
        let event = getSharedStateUpdateEvent()
        
        // verify
        XCTAssertNil(event.regionEventType)
    }
}
