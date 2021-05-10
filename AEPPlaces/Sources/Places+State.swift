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

extension Places {
    func getSharedStateData() -> [String: Any] {
        var data: [String: Any] = [:]
        
        // ensure membership data is still valid and clear it out if it's expired
        if !membershipDataIsValid {
            clearMembershipData()
        }
        
        // add nearby points of interest
        if !nearbyPois.isEmpty {
            data[PlacesConstants.SharedStateKey.NEARBY_POIS] = poisToStringMap(pois: nearbyPois)
        }
        
        // add the current poi
        if currentPoi != nil {
            data[PlacesConstants.SharedStateKey.CURRENT_POI] = currentPoi!
        }
        
        // add the last entered poi
        if lastEnteredPoi != nil {
            data[PlacesConstants.SharedStateKey.LAST_ENTERED_POI] = lastEnteredPoi!
        }
        
        // add the last exited poi
        if lastExitedPoi != nil {
            data[PlacesConstants.SharedStateKey.LAST_EXITED_POI] = lastExitedPoi!
        }
        
        // add location authorization status string
        data[PlacesConstants.SharedStateKey.AUTH_STATUS] = authStatus.stringValue
                
        // add membership timestamp
        if membershipValidUntil != nil {
            data[PlacesConstants.SharedStateKey.VALID_UNTIL] = membershipValidUntil!
        }
        
        return data
    }
    
    func clearClientData() {
        nearbyPois.removeAll()
        userWithinPois.removeAll()
        currentPoi = nil
        lastEnteredPoi = nil
        lastExitedPoi = nil
        lastKnownLatitude = PlacesConstants.DefaultValues.INVALID_LAT_LON
        lastKnownLongitude = PlacesConstants.DefaultValues.INVALID_LAT_LON
        authStatus = .notDetermined
        membershipValidUntil = nil
        
        updatePersistence()
    }
    
    func updateMembershipValidUntil() {
        membershipValidUntil = Date().timeIntervalSince1970 + (membershipTtl ?? 0)
        updatePersistence()
    }
    
    /// Set the Points of Interest near the current location of the device.
    ///
    /// // TODO: are we still triggering entries in this case?
    /// This method returns a list of POIs that the user has newly entered.
    /// The caller is responsible for dispatching entry events for these entries.
    /// This method will update `currentPoi` and `lastEnteredPoi` when necessary.
    ///
    /// - Parameter pois: an array of new nearby Points of Interest that need to be processed
    /// - Returns: an array of `PointOfInterest` objects that the user has newly entered
    func processNewNearbyPois(_ pois: [PointOfInterest]) -> [PointOfInterest] {
        // current poi is always reset when we have a new list of POIs
        currentPoi = nil
                
        // initialize our return value
        var newlyEnteredPois: [PointOfInterest] = []
        
        // quick check to make sure we have new pois
        if pois.isEmpty {
            nearbyPois.removeAll()
            userWithinPois.removeAll()
        } else {
            var newNearbyPois: [String: PointOfInterest] = [:]
            var newUserWithinPois: [String: PointOfInterest] = [:]
            var lastEnteredPoiHasBeenUpdated = false
            for poi in pois {
                // always add the poi to our list of new pois
                newNearbyPois[poi.identifier] = poi
                
                // check for poi membership
                if poi.userIsWithin {
                    // add poi to our list of new userWithinPois map
                    newUserWithinPois[poi.identifier] = poi
                    
                    // only add this poi to the newlyEnteredPois if the poi isn't in the existing list
                    if userWithinPois[poi.identifier] != nil {
                        newlyEnteredPois.append(poi)
                    }
                    
                    // the first poi in this list is the closest to the requested location, so we only
                    // want to set lastEnteredPoi one time while iterating in this loop
                    if !lastEnteredPoiHasBeenUpdated {
                        Log.trace(label: PlacesConstants.LOG_TAG, "\(#function) updating lastEnteredPoi - name: \(poi.name), identifier: \(poi.identifier).")
                        lastEnteredPoiHasBeenUpdated = true
                        lastEnteredPoi = poi
                    }
                    
                    updateCurrentPoiIfNecessary(poi)
                }
            }
            
            nearbyPois = newNearbyPois
            userWithinPois = newUserWithinPois
        }
        
        updateMembershipValidUntil()
        updatePersistence()
        return newlyEnteredPois
    }
    
    /// Process a `PlacesRegionEvent` and update current, last entered, and last exited pois when applicable
    ///
    /// - Parameters:
    ///   - event: the type of region event being processed
    ///   - forPoi: the `PointOfInterest` that triggered the event
    func processRegionEvent(_ event: PlacesRegionEvent, forPoi poi: PointOfInterest) {
        switch event {
        case .entry:
            Log.trace(label: PlacesConstants.LOG_TAG, "\(#function) updating lastEnteredPoi - name: \(poi.name), identifier: \(poi.identifier).")
            lastEnteredPoi = poi
            
            // make sure this poi is in our list of userWithinPois - it should already be there
            if userWithinPois[poi.identifier] == nil {
                userWithinPois[poi.identifier] = poi
            }
        case .exit:
            Log.trace(label: PlacesConstants.LOG_TAG, "\(#function) updating lastExitedPoi - name: \(poi.name), identifier: \(poi.identifier).")
            lastExitedPoi = poi
            
            // reset the currentPoi so it can be recalculated later
            currentPoi = nil
            
            // remove the poi from our userWithinPois list
            userWithinPois.removeValue(forKey: poi.identifier)
        case .none:
            Log.trace(label: PlacesConstants.LOG_TAG, "\(#function) processing .none region event - you shouldn't ever see this!")
        }
        
        updateMembershipValidUntil()
        recalculateCurrentPoi()
        updatePersistence()
    }
    
    func clearMembershipData() {
        // clear locals
        currentPoi = nil
        lastEnteredPoi = nil
        lastExitedPoi = nil
        membershipValidUntil = nil
        
        // clear persistence
        dataStore.setCurrentPoi(nil)
        dataStore.setLastEnteredPoi(nil)
        dataStore.setLastExitedPoi(nil)
        dataStore.setMembershipValidUntil(nil)
    }
    
    func loadPersistence() {
        nearbyPois = dataStore.nearbyPois
        userWithinPois = dataStore.userWithinPois
        currentPoi = dataStore.currentPoi
        lastEnteredPoi = dataStore.lastEnteredPoi
        lastExitedPoi = dataStore.lastExitedPoi
        lastKnownLatitude = dataStore.lastKnownLatitude
        lastKnownLongitude = dataStore.lastKnownLongitude
        authStatus = dataStore.authStatus
        membershipValidUntil = dataStore.membershipValidUntil
    }
    
    private var membershipDataIsValid: Bool {
        return Date().timeIntervalSince1970 < membershipValidUntil ?? 0
    }
    
    private func poisToStringMap(pois: [String: PointOfInterest]) -> [String: String] {
        var poiStringMap: [String: String] = [:]
        
        for poi in pois.values {
            poiStringMap[poi.identifier] = poi.toJsonString()
        }
        
        return poiStringMap
    }
    
    private func recalculateCurrentPoi() {
        if userWithinPois.isEmpty {
            currentPoi = nil
            return
        }
        
        for poi in userWithinPois.values {
            updateCurrentPoiIfNecessary(poi)
        }
    }
    
    private func updateCurrentPoiIfNecessary(_ poi: PointOfInterest) {
        if currentPoi == nil || poi.hasPriorityOver(currentPoi!) {
            currentPoi = poi
        }
    }
    
    private func updatePersistence() {
        dataStore.setNearbyPois(nearbyPois)
        dataStore.setUserWithinPois(userWithinPois)
        dataStore.setCurrentPoi(currentPoi)
        dataStore.setLastEnteredPoi(lastEnteredPoi)
        dataStore.setLastExitedPoi(lastExitedPoi)
        dataStore.setLastKnownLatitude(lastKnownLatitude)
        dataStore.setLastKnownLongitude(lastKnownLongitude)
        dataStore.setAuthStatus(authStatus)
        dataStore.setMembershipValidUntil(membershipValidUntil)
    }
    
}
