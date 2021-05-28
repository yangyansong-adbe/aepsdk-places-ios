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

import CoreLocation
import Foundation

@available(iOS 14, *)
extension CLAccuracyAuthorization {
    init?(fromString: String) {
        switch fromString {
        case "full":
            self = .fullAccuracy
        case "reduced":
            self = .reducedAccuracy
        default:
            return nil
        }
    }

    /// Get the `String` representation of a `CLAccuracyAuthorization`
    /// - Returns: the `String` representation of `self`
    var stringValue: String {
        switch self {
        case .fullAccuracy:
            return "full"
        case .reducedAccuracy:
            return "reduced"
        @unknown default:
            return "unknown"
        }
    }
}
