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
import AEPCore

extension Event {
    // MARK: - Event Type/Source/Owner Detection
    var isPlacesRequestEvent: Bool {
        return type == EventType.places && source == EventSource.requestContent
    }
    
    var isSharedStateUpdateEvent: Bool {
        return type == EventType.hub && source == EventSource.sharedState
    }
    
    // MARK: - Configuration, Privacy & Settings
    var sharedStateOwner: String? {
        return data?[PlacesConstants.EventDataKey.SHARED_STATE_OWNER] as? String
    }
    
    var configurationPlacesLibraries: [[String: Any]]? {
        return data?[PlacesConstants.EventDataKey.Configuration.PLACES_LIBRARIES] as? [[String: Any]]
    }
    
    var configurationPlacesEndpoint: String? {
        return data?[PlacesConstants.EventDataKey.Configuration.PLACES_ENDPOINT] as? String
    }
    
    var configurationPlacesMembershipTtl: TimeInterval? {
        return data?[PlacesConstants.EventDataKey.Configuration.PLACES_MEMBERSHIP_TTL] as? TimeInterval
    }
    
    var privacyStatus: String? {
        return data?[PlacesConstants.EventDataKey.Configuration.GLOBAL_CONFIG_PRIVACY] as? String
    }
        
    var locationAuthorizationStatus: String? {
        return data?[PlacesConstants.EventDataKey.Places.AUTH_STATUS] as? String
    }
    
    // MARK: - Get Nearby Places
    var placesRequestType: String? {
        return data?[PlacesConstants.EventDataKey.Places.REQUEST_TYPE] as? String
    }
    
    var latitude: Double? {
        return data?[PlacesConstants.EventDataKey.Places.LATITUDE] as? Double
    }
    
    var longitude: Double? {
        return data?[PlacesConstants.EventDataKey.Places.LONGITUDE] as? Double
    }
    
    var requestedPoiCount: Int? {
        return data?[PlacesConstants.EventDataKey.Places.COUNT] as? Int
    }
    
    var placesQueryResponseCode: PlacesQueryResponseCode? {
        return PlacesQueryResponseCode(rawValue: data?[PlacesConstants.EventDataKey.Places.RESPONSE_STATUS] as? Int ?? -1)
    }
    
    // MARK: - Process Region Events
    var regionId: String? {
        return data?[PlacesConstants.EventDataKey.Places.REGION_ID] as? String
    }
    
    var regionEventType: String? {
        return data?[PlacesConstants.EventDataKey.Places.REGION_EVENT_TYPE] as? String
    }
}
