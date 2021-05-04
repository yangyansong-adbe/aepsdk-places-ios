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

enum PlacesAuthorizationStatus: Int {
    case unknown = 0
    case restricted
    case denied
    case always
    case whenInUse
        
    /// Converts an `Int` to its respective `PlacesAuthorizationStatus`
    /// If `fromRawValue` does not correspond to a valid `PlacesAuthorizationStatus`,
    /// calling this method will return `PlacesAuthorizationStatus.unknown`
    ///
    /// - Parameter fromRawValue: an `Int` representation of a `PlacesAuthorizationStatus`
    /// - Returns: a `PlacesAuthorizationStatus` representing the passed-in `Int`
    init(fromRawValue: Int) {
        self = PlacesAuthorizationStatus(rawValue: fromRawValue) ?? .unknown
    }
    
    init(fromStringValue: String) {
        switch fromStringValue {
        case "unknown":
            self = PlacesAuthorizationStatus(fromRawValue: 0)
        case "restricted":
            self = PlacesAuthorizationStatus(fromRawValue: 1)
        case "denied":
            self = PlacesAuthorizationStatus(fromRawValue: 2)
        case "always":
            self = PlacesAuthorizationStatus(fromRawValue: 3)
        case "whenInUse":
            self = PlacesAuthorizationStatus(fromRawValue: 4)
        default:
            self = PlacesAuthorizationStatus(fromRawValue: 0)
        }
    }
    
    /// Get the `String` representation of a `PlacesAuthorizationStatus` enum
    /// - Returns: the `String` representation of `self`
    func stringValue() -> String {
        switch self {
        case .unknown:
            return "unknown"
        case .restricted:
            return "restricted"
        case .denied:
            return "denied"
        case .always:
            return "always"
        case .whenInUse:
            return "whenInUse"        
        }
    }
}
