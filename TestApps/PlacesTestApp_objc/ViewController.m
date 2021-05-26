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

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
@import AEPPlaces;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction) getNearbyPois:(id)sender {
    CLLocation *location = [[CLLocation alloc] initWithLatitude:40.4350229 longitude:-111.8918356];
    [AEPMobilePlaces getNearbyPointsOfInterest:location limit:10 callback:^(NSArray<AEPPlacesPoi *> *pois, AEPPlacesQueryResponseCode responseCode) {
        NSLog(@"responseCode: %ld", (long)responseCode);
        NSLog(@"nearbyPois: %@", pois);
    }];
}

- (IBAction) processRegionEvent:(id)sender {
    // starbucks lehi
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:CLLocationCoordinate2DMake(40.3886845, -111.8284979) radius:100 identifier:@"877677e4-3004-46dd-a8b1-a609bd65a428"];
    
    // adobe lehi
    // CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:CLLocationCoordinate2DMake(40.4350117, -111.8918432) radius:150 identifier:@"0f437cb7-df9a-4431-bec1-18af523b2dcf"];
    
    [AEPMobilePlaces processRegionEvent:AEPPlacesRegionEventEntry forRegion:region];
}

- (IBAction) getCurrentPointsOfInterest:(id)sender {    
    [AEPMobilePlaces getCurrentPointsOfInterest:^(NSArray<AEPPlacesPoi *> *pois) {
        NSLog(@"currentPois: %@", pois);
    }];
}

- (IBAction) getLastKnownLocation:(id)sender {
    [AEPMobilePlaces getLastKnownLocation:^(CLLocation *location) {
        if (location) {
            NSLog(@"location returned from closure: (%f, %f)", location.coordinate.latitude, location.coordinate.longitude);
        }
    }];
}

- (IBAction) setAccuracyAuthorization:(id)sender {
    [AEPMobilePlaces setAccuracyAuthorization:CLAccuracyAuthorizationFullAccuracy];
}

- (IBAction) setAuthorizationStatus:(id)sender {
    [AEPMobilePlaces setAuthorizationStatus:kCLAuthorizationStatusAuthorizedAlways];
}

- (IBAction) clear:(id)sender {
    [AEPMobilePlaces clear];
}

@end
