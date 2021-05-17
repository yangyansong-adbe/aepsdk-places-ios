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
@testable import AEPPlaces

class MockPlacesQueryService: PlacesQueryService {
    var getNearbyPlacesWasCalled = false
    var invokedLat: Double?
    var invokedLon: Double?
    var invokedCount: Int?
    var returnValue: PlacesQueryServiceResult?
    
    override func getNearbyPlaces(lat: Double, lon: Double, count: Int, configuration: PlacesConfiguration, completion: @escaping (PlacesQueryServiceResult) -> Void) {
        getNearbyPlacesWasCalled = true
        invokedLat = lat
        invokedLon = lon
        invokedCount = count
        completion(returnValue ?? PlacesQueryServiceResult(pois: nil, response: .unknownError))
    }
}
