# Adobe Experience Platform - Places extension for iOS

## BETA
AEPPlaces is currently in Beta. Use of this code is by invitation only and not otherwise supported by Adobe. Please contact your Adobe Customer Success Manager to learn more.

By using the Beta, you hereby acknowledge that the Beta is provided "as is" without warranty of any kind. Adobe shall have no obligation to maintain, correct, update, change, modify or otherwise support the Beta. You are advised to use caution and not to rely in any way on the correct functioning or performance of such Beta and/or accompanying materials.

## About this project

Adobe Experience Platform Places Extension is an extension for the [Adobe Experience Platform Swift SDK](https://github.com/adobe/aepsdk-core-ios).

The AEPPlaces extension allows you to track geolocation events as defined in the Adobe Places UI and in Adobe Launch rules.

## Requirements
- Xcode 11.x
- Swift 5.x

## Current version
The AEPPlaces extension for iOS is currently in Beta development.

## Installation

### Binaries

To generate `AEPPlaces.xcframework`, run the following command from the root directory:

```
make archive
```

This will generate an XCFramework under the `build` folder. Drag and drop all the .xcframeworks to your app target.

### [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

```ruby
# Podfile
use_frameworks!

target 'YOUR_TARGET_NAME' do
      pod 'AEPPlaces', :git => 'git@github.com:adobe/aepsdk-places-ios.git', :branch => 'main'
      pod 'AEPEdge', :git => 'git@github.com:adobe/aepsdk-edge-ios.git', :branch => 'main'
      pod 'AEPEdgeIdentity', :git => 'git@github.com:adobe/aepsdk-edgeidentity-ios.git', :branch => 'main'
      pod 'AEPCore', :git => 'git@github.com:adobe/aepsdk-core-ios.git', :branch => 'main'
      pod 'AEPServices', :git => 'git@github.com:adobe/aepsdk-core-ios.git', :branch => 'main'
      pod 'AEPRulesEngine', :git => 'git@github.com:adobe/aepsdk-rulesengine-ios.git', :branch => 'main'
end
```

### [Swift Package Manager](https://github.com/apple/swift-package-manager)

To add the AEPPlaces Package to your application, from the Xcode menu select:

`File > Swift Packages > Add Package Dependency...`

Enter the URL for the AEPPlaces package repository: `https://github.com/adobe/aepsdk-places-ios.git`.

When prompted, make sure you change the branch to `main`. 

Alternatively, if your project has a `Package.swift` file, you can add AEPPlaces directly to your dependencies:

```
dependencies: [
    .package(url: "https://github.com/adobe/aepsdk-places-ios.git", .branch("main"))
],
targets: [
    .target(name: "YourTarget", 
            dependencies: ["AEPPlaces"], 
            path: "your/path")
]
```

## Documentation
Additional documentation for configuration and sdk usage can be found under the [Documentation](Documentation/README.md) directory.

## Setup Demo Application
The AEP Places Demo application is a sample app which retrieving nearby Points of Interest and triggering region events.

## Contributing
Looking to contribute to this project? Please review our [Contributing guidelines](.github/CONTRIBUTING.md) prior to opening a pull request.

We look forward to working with you!

## Licensing
This project is licensed under the Apache V2 License. See [LICENSE](LICENSE) for more information.
