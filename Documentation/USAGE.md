# AEPPlaces Public APIs

## Functions

| `static func clear()` | `+ (void) clear;` |
| `public static var extensionVersion: String` | `+ (nonnull NSString*) extensionVersion;` |
| `static func getCurrentPointsOfInterest(_ closure: @escaping ([PointOfInterest]) -> Void)` | `+ (void) getCurrentPointsOfInterest: (nullable void (^) (NSArray<ACPPlacesPoi*>* _Nullable userWithinPoi)) callback;` |
| `static func getLastKnownLocation(_ closure: @escaping (CLLocation?) -> Void)` | `+ (void) getLastKnownLocation: (nullable void (^) (CLLocation* _Nullable lastLocation)) callback;` |
| `static func getNearbyPointsOfInterest(forLocation location: CLLocation, withLimit limit: UInt, closure: @escaping ([PointOfInterest], PlacesQueryResponseCode) -> Void)` | `+ (void) getNearbyPointsOfInterest: (nonnull CLLocation*) currentLocation limit: (NSUInteger) limit callback: (nullable void (^) (NSArray<ACPPlacesPoi*>* _Nullable nearbyPoi)) callback;` |
| | `+ (void) getNearbyPointsOfInterest: (nonnull CLLocation*) currentLocation limit: (NSUInteger) limit callback: (nullable void (^) (NSArray<ACPPlacesPoi*>* _Nullable nearbyPoi)) callback errorCallback: (nullable void (^) (ACPPlacesRequestError result)) errorCallback;` |
| `static func processRegionEvent(_ regionEvent: PlacesRegionEvent, forRegion region: CLRegion)` | `+ (void) processRegionEvent: (nonnull CLRegion*) region forRegionEventType: (ACPRegionEventType) eventType;` |
| Use `MobileCore.registerExtensions([Places.self])` | `+ (void) registerExtension;` |
| `static func setAuthorizationStatus(status: CLAuthorizationStatus)` | `+ (void) setAuthorizationStatus: (CLAuthorizationStatus) status;` |
