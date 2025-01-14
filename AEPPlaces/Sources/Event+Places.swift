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

    var isConfigSharedStateChange: Bool {
        return sharedStateOwner == PlacesConstants.EventDataKey.Configuration.SHARED_STATE_NAME
    }

    var privacyStatus: String? {
        return data?[PlacesConstants.EventDataKey.Configuration.GLOBAL_CONFIG_PRIVACY] as? String
    }

    var locationAuthorizationStatus: String? {
        return data?[PlacesConstants.EventDataKey.Places.AUTH_STATUS] as? String
    }

    var locationAccuracy: String? {
        return data?[PlacesConstants.EventDataKey.Places.ACCURACY] as? String
    }

    // MARK: - Request Type handling
    var placesRequestType: String? {
        return data?[PlacesConstants.EventDataKey.Places.REQUEST_TYPE] as? String
    }

    var isGetNearbyPlacesRequestType: Bool {
        return placesRequestType == PlacesConstants.EventDataKey.Places.RequestType.GET_NEARBY_PLACES
    }

    var isProcessRegionEventRequestType: Bool {
        return placesRequestType == PlacesConstants.EventDataKey.Places.RequestType.PROCESS_REGION_EVENT
    }

    var isGetUserWithinPlacesRequestType: Bool {
        return placesRequestType == PlacesConstants.EventDataKey.Places.RequestType.GET_USER_WITHIN_PLACES
    }

    var isGetLastKnownLocationRequestType: Bool {
        return placesRequestType == PlacesConstants.EventDataKey.Places.RequestType.GET_LAST_KNOWN_LOCATION
    }

    var isResetRequestType: Bool {
        return placesRequestType == PlacesConstants.EventDataKey.Places.RequestType.RESET
    }

    var isSetAuthorizationStatusRequestType: Bool {
        return placesRequestType == PlacesConstants.EventDataKey.Places.RequestType.SET_AUTHORIZATION_STATUS
    }

    var isSetAccuracyRequestType: Bool {
        return placesRequestType == PlacesConstants.EventDataKey.Places.RequestType.SET_ACCURACY
    }

    // MARK: - Get Nearby Places
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

    var nearbyPois: [[String: Any]]? {
        return data?[PlacesConstants.SharedStateKey.NEARBY_POIS] as? [[String: Any]]
    }

    var userWithinPois: [[String: Any]]? {
        return data?[PlacesConstants.SharedStateKey.USER_WITHIN_POIS] as? [[String: Any]]
    }

    // MARK: - Process Region Events
    var regionId: String? {
        return data?[PlacesConstants.EventDataKey.Places.REGION_ID] as? String
    }

    var regionEventType: PlacesRegionEvent? {
        return PlacesRegionEvent.fromString(data?[PlacesConstants.EventDataKey.Places.REGION_EVENT_TYPE] as? String ?? "")
    }
}
