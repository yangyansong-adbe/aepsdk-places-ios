# Migration from ACPPlaces to AEPPlaces

This page gives an overview of how to migrate an ACPPlaces implementation to use AEPPlaces.  

## New APIs
The table below shows each of the AEPPlaces APIs and the ACPPlaces API they are replacing:

| ACPPlaces API (Objective-c)<br/><br/>class name: `ACPPlaces` | AEPPlaces API (Swift)<br/><br/>class name: `Places` | AEPPlaces API (Objective-c)<br/><br/>class name: `AEPMobilePlaces` |
| ------------- | ------------- | ------------- |
| `+ (void) clear;` | `static func clear()` | `+ (void) clear;` |
| `+ (nonnull NSString*) extensionVersion;` | `static var extensionVersion: String` | `+ (nonnull NSString*) extensionVersion;` |
| `+ (void) getCurrentPointsOfInterest: (nullable void (^) (NSArray<ACPPlacesPoi*>* _Nullable userWithinPoi)) callback;` | `static func getCurrentPointsOfInterest(_ closure: @escaping ([PointOfInterest]) -> Void)` | `+ (void) getCurrentPointsOfInterest: ^(NSArray<AEPPlacesPoi *> * _Nonnull pois)closure;` |
| `+ (void) getLastKnownLocation: (nullable void (^) (CLLocation* _Nullable lastLocation)) callback;` | `static func getLastKnownLocation(_ closure: @escaping (CLLocation?) -> Void)` |
| `+ (void) getNearbyPointsOfInterest: (nonnull CLLocation*) currentLocation limit: (NSUInteger) limit callback: (nullable void (^) (NSArray<ACPPlacesPoi*>* _Nullable nearbyPoi)) callback;` | `static func getNearbyPointsOfInterest(forLocation location: CLLocation, withLimit limit: UInt, closure: @escaping ([PointOfInterest], PlacesQueryResponseCode) -> Void)` |
| `+ (void) getNearbyPointsOfInterest: (nonnull CLLocation*) currentLocation limit: (NSUInteger) limit callback: (nullable void (^) (NSArray<ACPPlacesPoi*>* _Nullable nearbyPoi)) callback errorCallback: (nullable void (^) (ACPPlacesRequestError result)) errorCallback;` | |
| `+ (void) processRegionEvent: (nonnull CLRegion*) region forRegionEventType: (ACPRegionEventType) eventType;` | `static func processRegionEvent(_ regionEvent: PlacesRegionEvent, forRegion region: CLRegion)` |
| `+ (void) registerExtension;` | Use `MobileCore.registerExtensions([Places.self])` |
| `+ (void) setAuthorizationStatus: (CLAuthorizationStatus) status;` | `static func setAuthorizationStatus(status: CLAuthorizationStatus)` |

Some of the APIs are similar but have slight changes in behavior. The sections below help highlight those changes.



### getLastKnownLocation

##### AEPPlaces
If the SDK has no last known location, it will pass `nil` to the closure.

##### ACPPlaces
If the SDK has no last known location, it will pass a `CLLocation` object with a value of `999.999` for latitude and longitude to the callback.

### getNearbyPointsOfInterest

##### AEPPlaces
A single method supports retrieval of nearby Points of Interest. The provided closure accepts two parameters, representing the resulting nearby Points of Interest (if any) and the response code.

##### ACPPlaces
Two `getNearbyPointsOfInterest` methods exist. The overloaded version allows the caller to provide an `errorCallback` parameter in the case of failure.

### processRegionEvent

##### AEPPlaces
The order of parameters has the `PlacesRegionEvent` first, and the `CLRegion` that triggered the event second.

##### ACPPlaces
The order of parameters has the `CLRegion` that triggered the event first, and the `ACPRegionEventType` second.

### Class and Enum Name Changes

| AEPPlaces (Swift) | AEPPlaces (Objective-c) | ACPPlaces (Objective-c) |
| ----------------- | ----------------------- | ----------------------- |
| `PlacesQueryResponseCode` | `AEPlacesQueryResponseCode` | `ACPPlacesRequestError` |
| `PointOfInterest` | `AEPPlacesPoi` | `ACPPlacesPoi` |
| `PlacesRegionEvent` | `AEPPlacesRegionEvent` | `ACPRegionEventType` |
