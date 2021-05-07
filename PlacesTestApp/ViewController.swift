//
//  ViewController.swift
//  PlacesTestApp
//
//  Created by steve benedick on 4/30/21.
//

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
        Places.getNearbyPointsOfInterest(forLocation: location, withLimit: 10) { nearbyPois in
            print("nearbyPois: \(nearbyPois)")
        }
    }
    
    @IBAction func getLastKnownLocation(_ sender: Any) {
        Places.getLastKnownLocation() { location in
            if let location = location {
                print("location returned from closure: (\(location.coordinate.latitude), \(location.coordinate.longitude))")
            }
        }
    }
    
    @IBAction func clear(_ sender: Any) {
        Places.clear()
    }
    
    @IBAction func getCurrentPointsOfInterest(_ sender: Any) {
        Places.getCurrentPointsOfInterest() { currentPois in
            print("currentPois: \(currentPois)")
        }
    }
    
    @IBAction func processRegionEvent(_ sender: Any) {
        // starbucks lehi
        let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 40.3886845, longitude: -111.8284979), radius: 100, identifier: "877677e4-3004-46dd-a8b1-a609bd65a428")
        
        // adobe lehi
        // let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 40.4350117, longitude: -111.8918432), radius: 150, identifier: "0f437cb7-df9a-4431-bec1-18af523b2dcf")
                
        Places.processRegionEvent(.entry, forRegion: region)
    }
    
    @IBAction func setAuthorizationStatus(_ sender: Any) {
        Places.setAuthorizationStatus(status: .authorizedAlways)
    }
}

