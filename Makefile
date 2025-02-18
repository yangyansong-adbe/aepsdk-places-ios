export EXTENSION_NAME = AEPPlaces
export APP_NAME = PlacesTestApp
export APP_NAME_OBJC = PlacesTestApp_objc
PROJECT_NAME = $(EXTENSION_NAME)
TARGET_NAME_XCFRAMEWORK = $(EXTENSION_NAME).xcframework
SCHEME_NAME_XCFRAMEWORK = AEPPlacesXCF

SIMULATOR_ARCHIVE_PATH = ./build/ios_simulator.xcarchive/Products/Library/Frameworks/
IOS_ARCHIVE_PATH = ./build/ios.xcarchive/Products/Library/Frameworks/

setup:
	(pod install)

setup-tools: install-swiftlint install-githook

pod-repo-update:
	(pod repo update)

# pod repo update may fail if there is no repo (issue fixed in v1.8.4). Use pod install --repo-update instead
pod-install:
	(pod install --repo-update)

ci-pod-install:
	(bundle exec pod install --repo-update)

pod-update: pod-repo-update
	(pod update)

open:
	open $(PROJECT_NAME).xcworkspace

clean:
	(rm -rf build)

archive:
	xcodebuild archive -workspace $(PROJECT_NAME).xcworkspace -scheme $(SCHEME_NAME_XCFRAMEWORK) -archivePath "./build/ios.xcarchive" -sdk iphoneos -destination="iOS" SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES
	xcodebuild archive -workspace $(PROJECT_NAME).xcworkspace -scheme $(SCHEME_NAME_XCFRAMEWORK) -archivePath "./build/ios_simulator.xcarchive" -sdk iphonesimulator -destination="iOS Simulator" SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES
	xcodebuild -create-xcframework -framework $(SIMULATOR_ARCHIVE_PATH)$(EXTENSION_NAME).framework -framework $(IOS_ARCHIVE_PATH)$(EXTENSION_NAME).framework -output ./build/$(TARGET_NAME_XCFRAMEWORK)

test:
	@echo "######################################################################"
	@echo "### Unit Testing iOS"
	@echo "######################################################################"
	xcodebuild test -workspace $(PROJECT_NAME).xcworkspace -scheme $(PROJECT_NAME) -destination 'platform=iOS Simulator,name=iPhone 8' -derivedDataPath build/out -enableCodeCoverage YES

install-swiftlint:
	HOMEBREW_NO_AUTO_UPDATE=1 brew install swiftlint && brew cleanup swiftlint

install-githook:
	./tools/git-hooks/setup.sh

lint-autocorrect:
	(swiftlint autocorrect --format)

lint:
	(swiftlint lint Sources TestApps/$(APP_NAME))

build-test-apps:
	xcodebuild -workspace $(PROJECT_NAME).xcworkspace -scheme $(APP_NAME) -destination 'platform=iOS Simulator,name=iPhone 8'
	xcodebuild -workspace $(PROJECT_NAME).xcworkspace -scheme $(APP_NAME_OBJC) -destination 'platform=iOS Simulator,name=iPhone 8'

swift-build:
	swift build -Xswiftc "-sdk" -Xswiftc "`xcrun --sdk iphonesimulator --show-sdk-path`" -Xswiftc "-target" -Xswiftc "x86_64-apple-ios10.0-simulator"

# make check-version VERSION=3.1.0
check-version:
	(sh ./Scripts/version.sh $(VERSION))

test-spm-integration:
	(sh ./Scripts/test-spm.sh)

test-podspec:
	(sh ./Scripts/test-podspec.sh)
