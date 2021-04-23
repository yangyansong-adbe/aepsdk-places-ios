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

/// Represents a region event which is used to map a user's movement in and out of Places POIs
enum PlacesRegionEvent: String {
    case entry = "entry"
    case exit = "exit"
    case none = "none"
    
    /// Converts a `String` to its respective `PlacesRegionEvent`
    /// If `type` is not a valid `PlacesRegionEvent`, calling this method will return `PlacesRegionEvent.none`
    /// - Parameter type: a `String` representation of a `PlacesRegionEvent`
    /// - Returns: a `PlacesRegionEvent` representing the passed-in `String`
    static func fromString(_ type: String) -> PlacesRegionEvent {
        if type == "entry" {
            return .entry
        } else if type == "exit" {
            return .exit
        } else {
            return .none
        }
    }
}
