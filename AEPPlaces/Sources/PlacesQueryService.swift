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

class PlacesQueryService {
        
    func getNearbyPlaces(lat: Double, lon: Double, count: Int, configuration: PlacesConfiguration, completion: @escaping (PlacesQueryServiceResult) -> Void) {
        // make sure we have valid configuration
        if !configuration.isValid {
            Log.warning(label: PlacesConstants.LOG_TAG, "Call to retrieve nearby places from the Places Query Service failed - Places configuration is invalid.")
            completion(PlacesQueryServiceResult(response: .queryServiceUnavailable))
            return
        }
        
        // build the url to send to Places Query Service
        let urlBase = "https://\(configuration.endpoint)/\(PlacesConstants.QueryService.PLACES_EDGE_QUERY)/"
        let librariesVariable = "?\(getLibrariesUrlParameter(libraries: configuration.libraries))"
        let latVariable = "&\(PlacesConstants.QueryService.Json.LATITUDE)=\(lat)"
        let lonVariable = "&\(PlacesConstants.QueryService.Json.LONGITUDE)=\(lon)"
        let limitVariable = "&\(PlacesConstants.QueryService.Json.LIMIT)=\(count)"
        let urlString = urlBase + librariesVariable + latVariable + lonVariable + limitVariable
        guard let url = URL(string: urlString) else {
            Log.warning(label: PlacesConstants.LOG_TAG, "Unable to request nearby places from the Places Query Service - error creating a URL object from urlString: \(urlString)")
            completion(PlacesQueryServiceResult(response: .connectivityError))
            return
        }
        
        Log.trace(label: PlacesConstants.LOG_TAG, "Making a request to Places Query Service: \(urlString)")
        
        let networkService = ServiceProvider.shared.networkService
        let request = NetworkRequest(url: url,
                                     connectTimeout: PlacesConstants.QueryService.REQUEST_TIMEOUT,
                                     readTimeout: PlacesConstants.QueryService.REQUEST_TIMEOUT)
        
        networkService.connectAsync(networkRequest: request) { (connection) in
            if connection.responseCode == HttpConnectionConstants.ResponseCodes.HTTP_OK {
                guard let responseData = connection.data else {
                    Log.debug(label: PlacesConstants.LOG_TAG, "No nearby POIs.")
                    completion(PlacesQueryServiceResult(response: .ok))
                    return
                }
                
                guard let responseJson = try? JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as? [String: Any] else {
                    Log.debug(label: PlacesConstants.LOG_TAG, "Error parsing response from Places Query Service")
                    completion(PlacesQueryServiceResult(response: .serverResponseError))
                    return
                }
                
                guard let placesJson = responseJson[PlacesConstants.QueryService.Json.PLACES] as? [String: Any] else {
                    Log.debug(label: PlacesConstants.LOG_TAG, "No nearby POIs.")
                    completion(PlacesQueryServiceResult(response: .ok))
                    return
                }
                
                var nearbyPois: [PointOfInterest] = []
                
                // get pois that the user is within first
                if let membershipArray = placesJson[PlacesConstants.QueryService.Json.USER_WITHIN] as? [[String: Any]] {
                    for currentPoi in membershipArray {
                        if let poi = try? PointOfInterest(jsonObject: currentPoi, userIsWithin: true) {
                            nearbyPois.append(poi)
                        }
                    }
                }
                                
                // get other pois that he user is near
                if let nearbyArray = placesJson[PlacesConstants.QueryService.Json.POIS] as? [[String: Any]] {
                    for currentPoi in nearbyArray {
                        if let poi = try? PointOfInterest(jsonObject: currentPoi) {
                            nearbyPois.append(poi)
                        }
                    }
                }
                
                Log.debug(label: PlacesConstants.LOG_TAG, "Response from Places Query Service contained \(nearbyPois.count) nearby POIs.")
                completion(PlacesQueryServiceResult(pois: nearbyPois, response: .ok))
            } else {
                Log.debug(label: PlacesConstants.LOG_TAG, "Places Query Service responded with status code \(connection.responseCode ?? 0)")
                completion(PlacesQueryServiceResult(response: .serverResponseError))
            }
        }
    }
    
    
    
    private func getLibrariesUrlParameter(libraries: [PlacesLibrary]) -> String {
        var librariesString = ""
        for library in libraries {
            librariesString.append(librariesString.isEmpty ? "" : "&")
            librariesString.append("library=\(library.id)")
        }
        
        return librariesString
    }
}


