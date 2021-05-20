# AEPPlaces Public APIs

## Static Functions

- [clear](#clear)
- [extensionVersion](#extensionVersion)
- [getCurrentPointsOfInterest](#getCurrentPointsOfInterest)
- [getLastKnownLocation](#getLastKnownLocation)
- [getNearbyPointsOfInterest](#getNearbyPointsOfInterest)
- [processRegionEvent](#processRegionEvent)
- [registerExtension](#registerExtension)
- [setAuthorizationStatus](#setAuthorizationStatus)

<hr />

### clear

<b>AEPPlaces (Objective-c)</b>
```
+ (void) clear;
```

<b>AEPPlaces (Swift)</b>
```
static func clear()
```

<hr />

### extensionVersion

<b>ACPPlaces (Objective-c)</b>
```
+ (nonnull NSString*) extensionVersion;
```

<b>AEPPlaces (Objective-c)</b>
```
+ (nonnull NSString*) extensionVersion;
```

<b>AEPPlaces (Swift)</b>
```
static var extensionVersion: String
```

<hr />

### getCurrentPointsOfInterest

<b>ACPPlaces (Objective-c)</b>
```
+ (void) getCurrentPointsOfInterest: (nullable void (^) (NSArray<ACPPlacesPoi*>* _Nullable userWithinPoi)) callback;
```

<b>AEPPlaces (Objective-c)</b>
```
+ (void) getCurrentPointsOfInterest: ^(NSArray<AEPPlacesPoi*>* _Nonnull pois) closure;
```

<b>AEPPlaces (Swift)</b>
```
static func getCurrentPointsOfInterest(_ closure: @escaping ([PointOfInterest]) -> Void)
```

<hr />

### getLastKnownLocation

<b>ACPPlaces (Objective-c)</b>

> <b>Note</b>: If the SDK has no last known location, it will pass a `CLLocation` object with a value of `999.999` for latitude and longitude to the callback.

```
+ (void) getLastKnownLocation: (nullable void (^) (CLLocation* _Nullable lastLocation)) callback;
```

<b>AEPPlaces (Objective-c)</b>
```
+ (void) getLastKnownLocation: ^(CLLocation* _Nullable lastLocation) closure;
```

<b>AEPPlaces (Swift)</b>

> <b>Note</b>: If the SDK has no last known location, it will pass `nil` to the closure.

```
static func getLastKnownLocation(_ closure: @escaping (CLLocation?) -> Void)
```

<hr />

### getNearbyPointsOfInterest


<b>ACPPlaces (Objective-c)</b>

> <b>Note</b>: Two `getNearbyPointsOfInterest` methods exist. The overloaded version allows the caller to provide an `errorCallback` parameter in the case of failure.

```
// without error handling
+ (void) getNearbyPointsOfInterest: (nonnull CLLocation*) currentLocation
                             limit: (NSUInteger) limit
                          callback: (nullable void (^) (NSArray<ACPPlacesPoi*>* _Nullable nearbyPoi)) callback;

// with error handling
+ (void) getNearbyPointsOfInterest: (nonnull CLLocation*) currentLocation
                             limit: (NSUInteger) limit
                          callback: (nullable void (^) (NSArray<ACPPlacesPoi*>* _Nullable nearbyPoi)) callback
                     errorCallback: (nullable void (^) (ACPPlacesRequestError result)) errorCallback;
```

<b>AEPPlaces (Objective-c)</b>
```
+ (void) getNearbyPointsOfInterest: (nonnull CLLocation*) currentLocation
                             limit: (NSUInteger) limit
                          callback: ^ (NSArray<AEPPlacesPoi*>* _Nonnull, AEPPlacesQueryResponseCode) closure;
```

<b>AEPPlaces (Swift)</b>

> <b>Note</b>: Rather than providing an overloaded method, a single method supports retrieval of nearby Points of Interest. The provided closure accepts two parameters, representing the resulting nearby Points of Interest (if any) and the response code.

```
static func getNearbyPointsOfInterest(forLocation location: CLLocation,
                                      withLimit limit: UInt,
                                      closure: @escaping ([PointOfInterest], PlacesQueryResponseCode) -> Void)
```

<hr />

### processRegionEvent

<b>ACPPlaces (Objective-c)</b>

> <b>Note</b>: The order of parameters has the `CLRegion` that triggered the event first, and the `ACPRegionEventType` second.

```
+ (void) processRegionEvent: (nonnull CLRegion*) region
         forRegionEventType: (ACPRegionEventType) eventType;
```

<b>AEPPlaces (Objective-c)</b>
```
+ (void) processRegionEvent: (AEPRegionEventType) eventType
                  forRegion: (nonnull CLRegion*) region;
```

<b>AEPPlaces (Swift)</b>

> <b>Note</b>: The order of parameters has the `PlacesRegionEvent` first, and the `CLRegion` that triggered the event second. This aligns better with Swift API naming conventions.

```
static func processRegionEvent(_ regionEvent: PlacesRegionEvent,
                               forRegion region: CLRegion)
```

<hr />

### registerExtension

<b>ACPPlaces (Objective-c)</b>
```
+ (void) registerExtension;
```

<b>AEPPlaces (Objective-c)</b>

> <b>Note</b>: Registration occurs by passing `AEPMobilePlaces` to the `[AEPMobileCore registerExtensions:completion:]` API.

```
[AEPMobileCore registerExtensions:@[AEPMobilePlaces.class] completion:nil];
```

<b>AEPPlaces (Swift)</b>

> <b>Note</b>: Registration occurs by passing `Places` to the `MobileCore.registerExtensions` API.

```
MobileCore.registerExtensions([Places.self])
```

<hr />

### setAuthorizationStatus

<b>ACPPlaces (Objective-c)</b>
```
+ (void) setAuthorizationStatus: (CLAuthorizationStatus) status;
```

<b>AEPPlaces (Objective-c)</b>
```
+ (void) setAuthorizationStatus: (CLAuthorizationStatus) status;
```

<b>AEPPlaces (Swift)</b>
```
static func setAuthorizationStatus(status: CLAuthorizationStatus)
```

<hr />
