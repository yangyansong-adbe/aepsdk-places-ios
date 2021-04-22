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

struct PlacesConfiguration: Codable {
    private(set) var libraries: [PlacesLibrary]
    private(set) var endpoint: String
    private(set) var membershipTtl: Int64
    
    static func withEventData(_ eventData: [String: Any]) -> PlacesConfiguration? {
        guard let eventLibrariesData = eventData[PlacesConstants.EventDataKey.Configuration.PLACES_LIBRARIES] as? [[String: Any]] else {
            Log.debug(label: PlacesConstants.LOG_TAG, "Unable to create a PlacesConfiguration object - no libraries were found in the configuration Event Data.")
            return nil
        }
        
        // pull out our list of libraries
        var libraries: [PlacesLibrary] = []
        for currentLibrary in eventLibrariesData {
            // library 'id' is required
            guard let libraryId = currentLibrary[PlacesConstants.EventDataKey.Configuration.PLACES_LIBRARY_ID] as? String else {
                Log.debug(label: PlacesConstants.LOG_TAG, "Unable to create a PlacesLibrary - 'id' is required in configuration, but was not found")
                continue
            }
            
            // get optional 'name'
            let libraryName = currentLibrary[PlacesConstants.EventDataKey.Configuration.PLACES_LIBRARY_NAME] as? String ?? ""
            
            // add a new library to the array
            let placeLibrary = PlacesLibrary(id: libraryId, name: libraryName)
            libraries.append(placeLibrary)
        }
        
        // get the endpoint for Places Edge query requests
        let endpoint = eventData[PlacesConstants.EventDataKey.Configuration.PLACES_ENDPOINT] as? String ?? ""
        
        // get membership TTL setting
        let ttl = eventData[PlacesConstants.EventDataKey.Configuration.PLACES_MEMBERSHIP_TTL] as? Int64 ?? PlacesConstants.DefaultValues.MEMBERSHIP_TTL
        
        return PlacesConfiguration(libraries: libraries, endpoint: endpoint, membershipTtl: ttl)
    }
}
