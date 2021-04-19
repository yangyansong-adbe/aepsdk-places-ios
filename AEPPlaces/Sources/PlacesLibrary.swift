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

class PlacesLibrary {
    private(set) var libraryId: String
    private(set) var name: String
        
    init(libraryId: String, name: String) {
        self.libraryId = libraryId
        self.name = name
    }
    
    static func fromJsonString(_ jsonString: String) -> PlacesLibrary? {
        do {
            if let json = try JSONSerialization.jsonObject(with: jsonString.data(using: .utf8) ?? Data(),
                                                           options: .mutableContainers) as? [String: Any] {
                let newLib = json[PlacesConstants.EventDataKey.Configuration.PLACES_LIBRARY_ID]
                let newName = json[PlacesConstants.EventDataKey.Configuration.PLACES_LIBRARY_NAME]
                if newLib != nil && newName != nil {
                    return PlacesLibrary(libraryId: newLib as! String, name: newName as! String)
                } else {
                    Log.warning(label: PlacesConstants.LOG_TAG, "Unable to parse Places Library JSON: missing library ID or Name.")
                }
            }
        } catch let error as NSError {
            Log.warning(label: PlacesConstants.LOG_TAG, "Unable to parse Places Library JSON: \(error.localizedDescription)")
        }
        
        return nil
    }
        
    func toJsonString() -> String {
        // TODO: - c++ didn't have a closing } character, wonder if that was intentional...
        return "{ \"id\":\"\(libraryId)\", \"name\":\"\(name)\""
    }
}
