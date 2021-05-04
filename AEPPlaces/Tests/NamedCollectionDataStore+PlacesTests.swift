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
@testable import AEPServices

class NamedCollectionDataStorePlusPlacesTests: XCTestCase {
    
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
    
    static let JSON_STRING_SMALL_RADIUS = """
    {
        "regionid": "2345",
        "regionname": "yourplace",
        "latitude": 12.34,
        "longitude": 23.45,
        "radius": 100,
        "weight": 25,
        "libraryid": "mylib",
        "useriswithin": false,
        "regionmetadata": {
            "key1": "value1"
        }
    }
    """
    
    let mockDataStore = NamedCollectionDataStore(name: "testing")
    
    override func tearDownWithError() throws {
        // clear mock data store
        mockDataStore.remove(key: PlacesConstants.UserDefaults.PERSISTED_NEARBY_POIS)
        mockDataStore.remove(key: PlacesConstants.UserDefaults.PERSISTED_USER_WITHIN_POIS)
        mockDataStore.remove(key: PlacesConstants.UserDefaults.PERSISTED_CURRENT_POI)
        mockDataStore.remove(key: PlacesConstants.UserDefaults.PERSISTED_LAST_EXITED_POI)
        mockDataStore.remove(key: PlacesConstants.UserDefaults.PERSISTED_LAST_ENTERED_POI)
        mockDataStore.remove(key: PlacesConstants.UserDefaults.PERSISTED_LATITUDE)
        mockDataStore.remove(key: PlacesConstants.UserDefaults.PERSISTED_LONGITUDE)
        mockDataStore.remove(key: PlacesConstants.UserDefaults.PERSISTED_AUTH_STATUS)
        mockDataStore.remove(key: PlacesConstants.UserDefaults.PERSISTED_MEMBERSHIP_VALID_UNTIL)
    }
    
    // MARK: - Helpers
    func getStringMapOfPois() -> [String: String] {
        return [
            "1234": NamedCollectionDataStorePlusPlacesTests.JSON_STRING,
            "2345": NamedCollectionDataStorePlusPlacesTests.JSON_STRING_SMALL_RADIUS
        ]
    }
    
    func getPointOfInterest() -> PointOfInterest {
        return try! PointOfInterest(jsonString: NamedCollectionDataStorePlusPlacesTests.JSON_STRING)
    }
    
    // MARK: - Tests
    
    // MARK: - nearbyPois
    func testNearbyPoisHappy() throws {
        // setup
        mockDataStore.set(key: PlacesConstants.UserDefaults.PERSISTED_NEARBY_POIS, value: getStringMapOfPois())
        
        // test
        let result = mockDataStore.nearbyPois
        
        // verify
        XCTAssertEqual(2, result.count)
        let firstPoi = result["1234"]
        XCTAssertEqual("1234", firstPoi?.identifier)
        XCTAssertEqual("myplace", firstPoi?.name)
        let secondPoi = result["2345"]
        XCTAssertEqual("2345", secondPoi?.identifier)
        XCTAssertEqual("yourplace", secondPoi?.name)
    }
    
    func testNearbyPoisNoneInPersistence() throws {
        // test
        let result = mockDataStore.nearbyPois
        
        // verify
        XCTAssertEqual(0, result.count)
    }
    
    func testSetNearbyPoisHappy() throws {
        // setup
        let existingMap = ["1234": NamedCollectionDataStorePlusPlacesTests.JSON_STRING]
        mockDataStore.set(key: PlacesConstants.UserDefaults.PERSISTED_NEARBY_POIS, value: existingMap)
        let newMap = ["2345": try! PointOfInterest(jsonString: NamedCollectionDataStorePlusPlacesTests.JSON_STRING_SMALL_RADIUS)]
                
        // test
        mockDataStore.setNearbyPois(newMap)
        
        // verify
        let persistedValue = mockDataStore.getDictionary(key: PlacesConstants.UserDefaults.PERSISTED_NEARBY_POIS)
        XCTAssertNotNil(persistedValue)
        XCTAssertEqual(1, persistedValue!.count)
        let firstPoiString = persistedValue!["2345"] as! String
        XCTAssertTrue(firstPoiString.contains("\"regionid\":\"2345\""))
        XCTAssertTrue(firstPoiString.contains("\"regionname\":\"yourplace\""))
    }
    
    func testSetNearbyPoisParamEmpty() throws {
        // setup
        mockDataStore.set(key: PlacesConstants.UserDefaults.PERSISTED_NEARBY_POIS, value: getStringMapOfPois())
        
        // test
        mockDataStore.setNearbyPois([:])
        
        // verify
        XCTAssertNil(mockDataStore.getDictionary(key: PlacesConstants.UserDefaults.PERSISTED_NEARBY_POIS))
    }
    
    // MARK: - userWithinPois
    func testUserWithinPoisHappy() throws {
        // setup
        mockDataStore.set(key: PlacesConstants.UserDefaults.PERSISTED_USER_WITHIN_POIS, value: getStringMapOfPois())
        
        // test
        let result = mockDataStore.userWithinPois
        
        // verify
        XCTAssertEqual(2, result.count)
        let firstPoi = result["1234"]
        XCTAssertEqual("1234", firstPoi?.identifier)
        XCTAssertEqual("myplace", firstPoi?.name)
        let secondPoi = result["2345"]
        XCTAssertEqual("2345", secondPoi?.identifier)
        XCTAssertEqual("yourplace", secondPoi?.name)
    }
    
    func testUserWithinPoisNoneInPersistence() throws {
        // test
        let result = mockDataStore.userWithinPois
        
        // verify
        XCTAssertEqual(0, result.count)
    }
    
    func testSetUserWithinPoisHappy() throws {
        // setup
        let existingMap = ["1234": NamedCollectionDataStorePlusPlacesTests.JSON_STRING]
        mockDataStore.set(key: PlacesConstants.UserDefaults.PERSISTED_USER_WITHIN_POIS, value: existingMap)
        let newMap = ["2345": try! PointOfInterest(jsonString: NamedCollectionDataStorePlusPlacesTests.JSON_STRING_SMALL_RADIUS)]
        
        // test
        mockDataStore.setUserWithinPois(newMap)
        
        // verify
        let persistedValue = mockDataStore.getDictionary(key: PlacesConstants.UserDefaults.PERSISTED_USER_WITHIN_POIS)
        XCTAssertNotNil(persistedValue)
        XCTAssertEqual(1, persistedValue!.count)
        let firstPoiString = persistedValue!["2345"] as! String
        XCTAssertTrue(firstPoiString.contains("\"regionid\":\"2345\""))
        XCTAssertTrue(firstPoiString.contains("\"regionname\":\"yourplace\""))
    }
    
    func testSetUserWithinPoisParamEmpty() throws {
        // setup
        mockDataStore.set(key: PlacesConstants.UserDefaults.PERSISTED_USER_WITHIN_POIS, value: getStringMapOfPois())
        
        // test
        mockDataStore.setUserWithinPois([:])
        
        // verify
        XCTAssertNil(mockDataStore.getDictionary(key: PlacesConstants.UserDefaults.PERSISTED_USER_WITHIN_POIS))
    }
    
    // MARK: - currentPoi
    func testCurrentPoiHappy() throws {
        // setup
        mockDataStore.set(key: PlacesConstants.UserDefaults.PERSISTED_CURRENT_POI, value: NamedCollectionDataStorePlusPlacesTests.JSON_STRING)
        
        // test
        let result = mockDataStore.currentPoi
        
        // verify
        XCTAssertNotNil(result)
        XCTAssertEqual("1234", result?.identifier)
        XCTAssertEqual("myplace", result?.name)
    }
    
    func testCurrentPoiNoneInPersistence() throws {
        // test
        let result = mockDataStore.currentPoi
        
        // verify
        XCTAssertNil(result)
    }
    
    func testSetCurrentPoiHappy() throws {
        // setup
        mockDataStore.set(key: PlacesConstants.UserDefaults.PERSISTED_CURRENT_POI, value: NamedCollectionDataStorePlusPlacesTests.JSON_STRING_SMALL_RADIUS)
        
        // test
        mockDataStore.setCurrentPoi(getPointOfInterest())
        
        // verify
        let newPersistedValue = mockDataStore.getString(key: PlacesConstants.UserDefaults.PERSISTED_CURRENT_POI)!
        XCTAssertTrue(newPersistedValue.contains("\"regionid\":\"1234\""))
        XCTAssertTrue(newPersistedValue.contains("\"regionname\":\"myplace\""))
    }
    
    func testSetCurrentPoiEmpty() throws {
        // setup
        mockDataStore.set(key: PlacesConstants.UserDefaults.PERSISTED_CURRENT_POI, value: NamedCollectionDataStorePlusPlacesTests.JSON_STRING_SMALL_RADIUS)
        
        // test
        mockDataStore.setCurrentPoi(nil)
        
        // verify
        XCTAssertNil(mockDataStore.getString(key: PlacesConstants.UserDefaults.PERSISTED_CURRENT_POI))
    }
    
    // MARK: - lastEnteredPoi
    func testLastEnteredPoiHappy() throws {
        // setup
        mockDataStore.set(key: PlacesConstants.UserDefaults.PERSISTED_LAST_ENTERED_POI, value: NamedCollectionDataStorePlusPlacesTests.JSON_STRING)
        
        // test
        let result = mockDataStore.lastEnteredPoi
        
        // verify
        XCTAssertNotNil(result)
        XCTAssertEqual("1234", result?.identifier)
        XCTAssertEqual("myplace", result?.name)
    }
    
    func testLastEnteredPoiNoneInPersistence() throws {
        // test
        let result = mockDataStore.lastEnteredPoi
        
        // verify
        XCTAssertNil(result)
    }
    
    func testSetLastEnteredPoiHappy() throws {
        // setup
        mockDataStore.set(key: PlacesConstants.UserDefaults.PERSISTED_LAST_ENTERED_POI, value: NamedCollectionDataStorePlusPlacesTests.JSON_STRING_SMALL_RADIUS)
        
        // test
        mockDataStore.setLastEnteredPoi(getPointOfInterest())
        
        // verify
        let newPersistedValue = mockDataStore.getString(key: PlacesConstants.UserDefaults.PERSISTED_LAST_ENTERED_POI)!
        XCTAssertTrue(newPersistedValue.contains("\"regionid\":\"1234\""))
        XCTAssertTrue(newPersistedValue.contains("\"regionname\":\"myplace\""))
    }
    
    func testSetLastEnteredPoiEmpty() throws {
        // setup
        mockDataStore.set(key: PlacesConstants.UserDefaults.PERSISTED_LAST_ENTERED_POI, value: NamedCollectionDataStorePlusPlacesTests.JSON_STRING_SMALL_RADIUS)
        
        // test
        mockDataStore.setLastEnteredPoi(nil)
        
        // verify
        XCTAssertNil(mockDataStore.getString(key: PlacesConstants.UserDefaults.PERSISTED_LAST_ENTERED_POI))
    }
    
    // MARK: - lastExitedPoi
    func testLastExitedPoiHappy() throws {
        // setup
        mockDataStore.set(key: PlacesConstants.UserDefaults.PERSISTED_LAST_EXITED_POI, value: NamedCollectionDataStorePlusPlacesTests.JSON_STRING)
        
        // test
        let result = mockDataStore.lastExitedPoi
        
        // verify
        XCTAssertNotNil(result)
        XCTAssertEqual("1234", result?.identifier)
        XCTAssertEqual("myplace", result?.name)
    }
    
    func testLastExitedPoiNoneInPersistence() throws {
        // test
        let result = mockDataStore.lastExitedPoi
        
        // verify
        XCTAssertNil(result)
    }
    
    func testSetLastExitedPoiHappy() throws {
        // setup
        mockDataStore.set(key: PlacesConstants.UserDefaults.PERSISTED_LAST_EXITED_POI, value: NamedCollectionDataStorePlusPlacesTests.JSON_STRING_SMALL_RADIUS)
        
        // test
        mockDataStore.setLastExitedPoi(getPointOfInterest())
        
        // verify
        let newPersistedValue = mockDataStore.getString(key: PlacesConstants.UserDefaults.PERSISTED_LAST_EXITED_POI)!
        XCTAssertTrue(newPersistedValue.contains("\"regionid\":\"1234\""))
        XCTAssertTrue(newPersistedValue.contains("\"regionname\":\"myplace\""))
    }
    
    func testSetLastExitedPoiEmpty() throws {
        // setup
        mockDataStore.set(key: PlacesConstants.UserDefaults.PERSISTED_LAST_EXITED_POI, value: NamedCollectionDataStorePlusPlacesTests.JSON_STRING_SMALL_RADIUS)
        
        // test
        mockDataStore.setLastExitedPoi(nil)
        
        // verify
        XCTAssertNil(mockDataStore.getString(key: PlacesConstants.UserDefaults.PERSISTED_LAST_EXITED_POI))
    }
    
    // MARK: - lastKnownLatitude
    func testLastKnownLatitudeHappy() throws {
        // setup
        mockDataStore.set(key: PlacesConstants.UserDefaults.PERSISTED_LATITUDE, value: 12.34)
        
        // test
        let result = mockDataStore.lastKnownLatitude
        
        // verify
        XCTAssertEqual(12.34, result)
    }
    
    func testLastKnownLatitudeNoneInPersistence() throws {
        // test
        let result = mockDataStore.lastKnownLatitude
        
        // verify
        XCTAssertEqual(PlacesConstants.DefaultValues.INVALID_LAT_LON, result)
    }
    
    func testSetLastKnownLatitudeHappy() throws {
        // setup
        mockDataStore.set(key: PlacesConstants.UserDefaults.PERSISTED_LATITUDE, value: 12.34)
        
        // test
        mockDataStore.setLastKnownLatitude(44.44)
        
        // verify
        XCTAssertEqual(44.44, mockDataStore.getDouble(key: PlacesConstants.UserDefaults.PERSISTED_LATITUDE)!)
    }
    
    func testSetLastKnownLatitudeEmpty() throws {
        // setup
        mockDataStore.set(key: PlacesConstants.UserDefaults.PERSISTED_LATITUDE, value: 12.34)
        
        // test
        mockDataStore.setLastKnownLatitude(nil)
        
        // verify
        XCTAssertNil(mockDataStore.getDouble(key: PlacesConstants.UserDefaults.PERSISTED_LATITUDE))
    }
    
    // MARK: - lastKnownLongitude
    func testLastKnownLongitudeHappy() throws {
        // setup
        mockDataStore.set(key: PlacesConstants.UserDefaults.PERSISTED_LONGITUDE, value: 23.45)
        
        // test
        let result = mockDataStore.lastKnownLongitude
        
        // verify
        XCTAssertEqual(23.45, result)
    }
    
    func testLastKnownLongitudeNoneInPersistence() throws {
        // test
        let result = mockDataStore.lastKnownLongitude
        
        // verify
        XCTAssertEqual(PlacesConstants.DefaultValues.INVALID_LAT_LON, result)
    }
    
    func testSetLastKnownLongitudeHappy() throws {
        // setup
        mockDataStore.set(key: PlacesConstants.UserDefaults.PERSISTED_LONGITUDE, value: 23.45)
        
        // test
        mockDataStore.setLastKnownLongitude(44.44)
        
        // verify
        XCTAssertEqual(44.44, mockDataStore.getDouble(key: PlacesConstants.UserDefaults.PERSISTED_LONGITUDE)!)
    }
    
    func testSetLastKnownLongitudeEmpty() throws {
        // setup
        mockDataStore.set(key: PlacesConstants.UserDefaults.PERSISTED_LONGITUDE, value: 12.34)
        
        // test
        mockDataStore.setLastKnownLongitude(nil)
        
        // verify
        XCTAssertNil(mockDataStore.getDouble(key: PlacesConstants.UserDefaults.PERSISTED_LONGITUDE))
    }
    
    // MARK: - authStatus
    func testAuthStatusHappy() throws {
        // setup
        mockDataStore.set(key: PlacesConstants.UserDefaults.PERSISTED_AUTH_STATUS, value: "always")
        
        // test
        let result = mockDataStore.authStatus
        
        // verify
        XCTAssertEqual(PlacesAuthorizationStatus.always, result)
    }
    
    func testAuthStatusNoneInPersistence() throws {
        // test
        let result = mockDataStore.authStatus
        
        // verify
        XCTAssertEqual(PlacesAuthorizationStatus.unknown, result)
    }
    
    func testSetAuthStatusHappy() throws {
        // setup
        mockDataStore.set(key: PlacesConstants.UserDefaults.PERSISTED_AUTH_STATUS, value: "always")
        
        // test
        mockDataStore.setAuthStatus(.denied)
        
        // verify
        XCTAssertEqual("denied", mockDataStore.getString(key: PlacesConstants.UserDefaults.PERSISTED_AUTH_STATUS))
    }
    
    func testSetAuthStatusEmpty() throws {
        // setup
        mockDataStore.set(key: PlacesConstants.UserDefaults.PERSISTED_AUTH_STATUS, value: "always")
        
        // test
        mockDataStore.setAuthStatus(nil)
        
        // verify
        XCTAssertNil(mockDataStore.getString(key: PlacesConstants.UserDefaults.PERSISTED_AUTH_STATUS))
    }
    
    // MARK: - membershipValidUntil
    func testMembershipValidUntilHappy() throws {
        // setup
        mockDataStore.set(key: PlacesConstants.UserDefaults.PERSISTED_MEMBERSHIP_VALID_UNTIL, value: 552)
        
        // test
        let result = mockDataStore.membershipValidUntil
        
        // verify
        XCTAssertEqual(552, result)
    }
    
    func testMembershipValidUntilNoneInPersistence() throws {
        // test
        let result = mockDataStore.membershipValidUntil
        
        // verify
        XCTAssertNil(result)
    }
    
    func testSetMembershipValidUntilHappy() throws {
        // setup
        mockDataStore.set(key: PlacesConstants.UserDefaults.PERSISTED_MEMBERSHIP_VALID_UNTIL, value: 552)
        
        // test
        mockDataStore.setMembershipValidUntil(12345)
        
        // verify
        XCTAssertEqual(12345, mockDataStore.getDouble(key: PlacesConstants.UserDefaults.PERSISTED_MEMBERSHIP_VALID_UNTIL)!)
    }
    
    func testSetMembershipValidUntilEmpty() throws {
        // setup
        mockDataStore.set(key: PlacesConstants.UserDefaults.PERSISTED_MEMBERSHIP_VALID_UNTIL, value: 552)
        
        // test
        mockDataStore.setMembershipValidUntil(nil)
        
        // verify
        XCTAssertNil(mockDataStore.getDouble(key: PlacesConstants.UserDefaults.PERSISTED_MEMBERSHIP_VALID_UNTIL))
    }
}
