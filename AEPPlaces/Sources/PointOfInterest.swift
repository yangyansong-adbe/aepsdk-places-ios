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

import Foundation
import AEPServices

@objc(AEPPlacesPoi)
public class PointOfInterest: NSObject {
    var identifier: String
    var name: String
    var latitude: Double
    var longitude: Double
    var radius: Int
    var metaData: [String: String]
    var userIsWithin: Bool
    
    private var libraryId: String
    private var weight: Int
    
    /// Initializes a `PointOfInterest` object from a JSON String.
    ///
    /// - Parameters:
    ///   - jsonString: a JSON String containing keys and values to define a `PointOfInterest` object
    /// - Returns: a new `PointOfInterest` object
    /// - Throws: a `PlacesDataObjectInvalidInitialization` if JSON parsing fails
    init(jsonString: String) throws {
        do {
            if let json = try JSONSerialization.jsonObject(with: jsonString.data(using: .utf8) ?? Data(),
                                                           options: .mutableContainers) as? [String: Any] {
                identifier = json[PlacesConstants.EventDataKey.Places.REGION_ID] as? String ?? ""
                name = json[PlacesConstants.EventDataKey.Places.REGION_NAME] as? String ?? ""
                latitude = json[PlacesConstants.EventDataKey.Places.LATITUDE] as? Double ?? PlacesConstants.DefaultValues.INVALID_LAT_LON
                longitude = json[PlacesConstants.EventDataKey.Places.LONGITUDE] as? Double ?? PlacesConstants.DefaultValues.INVALID_LAT_LON
                radius = json[PlacesConstants.EventDataKey.Places.RADIUS] as? Int ?? 0
                weight = json[PlacesConstants.EventDataKey.Places.WEIGHT] as? Int ?? 0
                libraryId = json[PlacesConstants.EventDataKey.Places.LIBRARY_ID] as? String ?? ""
                userIsWithin = json[PlacesConstants.EventDataKey.Places.USER_IS_WITHIN] as? Bool ?? false
                metaData = json[PlacesConstants.EventDataKey.Places.REGION_META_DATA] as? [String: String] ?? [:]
            } else {
                Log.warning(label: PlacesConstants.LOG_TAG, "An error occurred while trying to read a PointOfInterest json string.")
                throw PlacesDataObjectInvalidInitialization(message: "Invalid JSON string")
            }
        } catch let error as NSError {
            Log.warning(label: PlacesConstants.LOG_TAG, "An error occurred while trying to read a PointOfInterest json string:  \(error.localizedDescription)")
            throw PlacesDataObjectInvalidInitialization(message: "Invalid JSON string")
        }
    }
    
    /// Initializes a `PointOfInterest` object from a Dictionary that represents an object returned by PlacesEdge.
    ///
    /// - Parameters:
    ///   - jsonObject: a map containing keys and values to define a `PointOfInterest` object
    ///   - userIsWithin: a `Bool` indicating whether the user is within this `PointOfInterest`
    /// - Returns: a new `PointOfInterest` object
    /// - Throws: a `PlacesDataObjectInvalidInitialization` if `jsonObject` does not contain a valid POI object
    init(jsonObject: [String: Any], userIsWithin: Bool? = false) throws {
        guard let poiInfo = jsonObject[PlacesConstants.QueryService.Json.POI] as? [Any] else {
            Log.warning(label: PlacesConstants.LOG_TAG, "An error occurred while trying to create a PointOfInterest from the Edge response.")
            throw PlacesDataObjectInvalidInitialization(message: "Invalid JSON Object")
        }
        
        if poiInfo.count != PlacesConstants.QueryService.EXPECTED_ARRAY_LENGTH {
            Log.warning(label: PlacesConstants.LOG_TAG, "The PointOfInterest does not contain the correct number of elements.")
            throw PlacesDataObjectInvalidInitialization(message: "Invalid JSON Object")
        }
        
        self.identifier = poiInfo[PlacesConstants.QueryService.Index.ID] as? String ?? ""
        self.name = poiInfo[PlacesConstants.QueryService.Index.NAME] as? String ?? ""
        self.latitude = poiInfo[PlacesConstants.QueryService.Index.LATITUDE] as? Double ?? PlacesConstants.DefaultValues.INVALID_LAT_LON
        self.longitude = poiInfo[PlacesConstants.QueryService.Index.LONGITUDE] as? Double ?? PlacesConstants.DefaultValues.INVALID_LAT_LON
        self.radius = poiInfo[PlacesConstants.QueryService.Index.RADIUS] as? Int ?? 0
        self.libraryId = poiInfo[PlacesConstants.QueryService.Index.LIBRARY_ID] as? String ?? ""
        self.weight = poiInfo[PlacesConstants.QueryService.Index.WEIGHT] as? Int ?? 0
        self.userIsWithin = userIsWithin!
        self.metaData = jsonObject[PlacesConstants.QueryService.Json.META_DATA] as? [String: String] ?? [:]
    }
    
    /// Converts and returns the contents of this `PointOfInterest` as a JSON string.
    /// If serialization fails, this method returns an empty string.
    /// - Returns: a JSON string representation of the calling object
    internal func toJsonString() -> String {
        var myMap: [String: Any] = [:]
        
        myMap[PlacesConstants.EventDataKey.Places.REGION_ID] = identifier
        myMap[PlacesConstants.EventDataKey.Places.REGION_NAME] = name
        myMap[PlacesConstants.EventDataKey.Places.LATITUDE] = latitude
        myMap[PlacesConstants.EventDataKey.Places.LONGITUDE] = longitude
        myMap[PlacesConstants.EventDataKey.Places.RADIUS] = radius
        myMap[PlacesConstants.EventDataKey.Places.WEIGHT] = weight
        myMap[PlacesConstants.EventDataKey.Places.LIBRARY_ID] = libraryId
        myMap[PlacesConstants.EventDataKey.Places.USER_IS_WITHIN] = userIsWithin
        myMap[PlacesConstants.EventDataKey.Places.REGION_META_DATA] = metaData
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: myMap, options: []) {
            return String(data: jsonData, encoding: .utf8) ?? ""
        }
        
        return ""
    }
    
    /// Determines if two `PointOfInterest` objects have the same identifier.
    /// - Parameter rhs: the other `PointOfInterest` object to compare against
    /// - Returns: true if both objects have the same value for `identifier`
    internal func equals(_ rhs: PointOfInterest) -> Bool {
        return identifier == rhs.identifier
    }
    
    /// Check if the current PointOfInterest has priority over the provided object.
    /// Priority is measured by weight - the lower the weight, the higher the priority.
    /// In the case that both weights are the same, the PointOfInterest with a smaller radius has priority.
    /// If both the weight and radius are equal, the calling PointOfInterest has priority.
    /// - Parameter rhs: the other PointOfInterest to compare against
    /// - Returns: true if the calling object has priority over the `rhs`
    internal func hasPriorityOver(_ rhs: PointOfInterest) -> Bool {
        if rhs.weight < weight {
            return false
        } else if rhs.weight == weight {
            return rhs.radius >= radius
        }
        
        return true
    }
}

public struct PlacesDataObjectInvalidInitialization: Error {
    public let message: String?
        
    public init(message: String? = nil) {
        self.message = message
    }
}
