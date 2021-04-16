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
import AEPServices

@objc(AEPMobilePlaces)
public class Places: NSObject, Extension {
    
    // MARK: - Extension protocol
    
    // MARK: properties
    public static var extensionVersion: String = PlacesConstants.EXTENSION_VERSION
    public var name: String = PlacesConstants.EXTENSION_NAME
    public var friendlyName: String = PlacesConstants.EXTENSION_NAME
    public var metadata: [String : String]?
    public var runtime: ExtensionRuntime
    
    // MARK: methods
    public required init?(runtime: ExtensionRuntime) {
        self.runtime = runtime
        
        super.init()
    }
    
    public func onRegistered() {
        
    }
    
    public func onUnregistered() {
        
    }
    
    public func readyForEvent(_ event: Event) -> Bool {
        return true
    }
    
    // MARK: -
}
