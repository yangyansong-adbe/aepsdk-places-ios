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

import UIKit
import AEPPlaces
import CoreLocation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func getNearbyPois(_ sender: Any) {
        let location = CLLocation(latitude: 40.4350229, longitude: -111.8918356)
        Places.getNearbyPointsOfInterest(forLocation: location, withLimit: 10) { (nearbyPois, responseCode) in
            print("responseCode: \(responseCode.rawValue) \nnearbyPois: \(nearbyPois)")
        }
    }
    
    @IBAction func processRegionEntryEvent(_ sender: Any) {
        // starbucks lehi
        let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 40.3886845, longitude: -111.8284979), radius: 100, identifier: "877677e4-3004-46dd-a8b1-a609bd65a428")
        
        // adobe lehi
        // let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 40.4350117, longitude: -111.8918432), radius: 150, identifier: "0f437cb7-df9a-4431-bec1-18af523b2dcf")
        
        Places.processRegionEvent(.entry, forRegion: region)
    }
    
    @IBAction func processRegionExitEvent(_ sender: Any) {
        // starbucks lehi
        let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 40.3886845, longitude: -111.8284979), radius: 100, identifier: "877677e4-3004-46dd-a8b1-a609bd65a428")
        
        // adobe lehi
        // let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 40.4350117, longitude: -111.8918432), radius: 150, identifier: "0f437cb7-df9a-4431-bec1-18af523b2dcf")
        
        Places.processRegionEvent(.exit, forRegion: region)
    }
    
    @IBAction func getCurrentPointsOfInterest(_ sender: Any) {
        Places.getCurrentPointsOfInterest() { currentPois in
            print("currentPois: \(currentPois)")
        }
    }
    
    @IBAction func getLastKnownLocation(_ sender: Any) {
        Places.getLastKnownLocation() { location in
            if let location = location {
                print("location returned from closure: (\(location.coordinate.latitude), \(location.coordinate.longitude))")
            }
        }
    }
    
    @IBAction func setAccuracyAuthorization(_ sender: Any) {
        Places.setAccuracyAuthorization(accuracy: .fullAccuracy)
    }
    
    @IBAction func setAuthorizationStatus(_ sender: Any) {
        Places.setAuthorizationStatus(status: .authorizedAlways)
    }
    
    @IBAction func clear(_ sender: Any) {
        Places.clear()
    }
}
