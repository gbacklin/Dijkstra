#!/bin/bash

FRAMEWORK=$1

# If remnants from a previous build exist, delete them.
if [ -d "./"$FRAMEWORK".xcframework" ]; then
rm -rf "./"$FRAMEWORK".xcframework"
fi
if [ -d "./"$FRAMEWORK"iOSSim.xcarchive" ]; then
rm -rf "./"$FRAMEWORK"iOSSim.xcarchive"
fi
if [ -d "./"$FRAMEWORK"iOSDev.xcarchive" ]; then
rm -rf "./"$FRAMEWORK"iOSDev.xcarchive"
fi
if [ -d "./"$FRAMEWORK"watchOSSim.xcarchive" ]; then
rm -rf "./"$FRAMEWORK"watchOSSim.xcarchive"
fi
if [ -d "./"$FRAMEWORK"watchOSDev.xcarchive" ]; then
rm -rf "./"$FRAMEWORK"watchOSDev.xcarchive"
fi
if [ -d "./"$FRAMEWORK"macOS.xcarchive" ]; then
rm -rf "./"$FRAMEWORK"macOS.xcarchive"
fi
if [ -d "./"$FRAMEWORK"macOSCat.xcarchive" ]; then
rm -rf "./"$FRAMEWORK"macOSCat.xcarchive"
fi
if [ -d "./"$FRAMEWORK"tvOSDev.xcarchive" ]; then
rm -rf "./"$FRAMEWORK"tvOSDev.xcarchive"
fi
if [ -d "./"$FRAMEWORK"tvOSSim.xcarchive" ]; then
rm -rf "./"$FRAMEWORK"tvOSSim.xcarchive"
fi

while [ -n "$2" ]; do # while loop starts
sudo xcode-select -switch /Applications/XcodeBeta/Xcode-beta.app
#sudo xcode-select -switch /Applications/Xcode11.1/Xcode.app
 
    case "$2" in
 
 #----- Make iOS & macCatalyst archive
    -ios) if [ -d "./"$FRAMEWORK"-iOS.xcframework" ]; then
	  rm -rf "./"$FRAMEWORK"-iOS.xcframework"
	  fi
	xcodebuild archive \
	-scheme  "$FRAMEWORK" \
	-archivePath "$FRAMEWORK"macOSCat.xcarchive \
	-sdk macosx \
	SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES SUPPORTS_MACCATALYST=YES

#----- Make iOS Simulator archive
	xcodebuild archive \
	-scheme  "$FRAMEWORK" \
	-archivePath "$FRAMEWORK"iOSSim.xcarchive \
	-sdk iphonesimulator \
	SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

#----- Make iOS device archive
	xcodebuild archive \
	-scheme  "$FRAMEWORK" \
	-archivePath "$FRAMEWORK"iOSDev.xcarchive \
	-sdk iphoneos \
	SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

echo "Creating XCFramework..."
	xcodebuild -create-xcframework \
		-framework ./"$FRAMEWORK"iOSSim.xcarchive/Products/Library/Frameworks/"$FRAMEWORK".framework \
		-framework ./"$FRAMEWORK"iOSDev.xcarchive/Products/Library/Frameworks/"$FRAMEWORK".framework \
		-framework ./"$FRAMEWORK"macOSCat.xcarchive/Products/Library/Frameworks/"$FRAMEWORK".framework \
		-output "$FRAMEWORK"-iOS.xcframework
	;; # Message for -ios option
 
#----- Make watchOS Simulator archive
    -watch) if [ -d "./"$FRAMEWORK"-watchOS.xcframework" ]; then
            rm -rf "./"$FRAMEWORK"-watchOS.xcframework"
            fi
	xcodebuild archive \
	-scheme  "$FRAMEWORK" \
	-archivePath "$FRAMEWORK"watchOSSim.xcarchive \
	-sdk watchsimulator \
	SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

#----- Make watchOS device archive
	xcodebuild archive \
	-scheme  "$FRAMEWORK" \
	-archivePath "$FRAMEWORK"watchOSDev.xcarchive \
	-sdk watchos \
	SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES 

echo "Creating XCFramework..."
	xcodebuild -create-xcframework \
		-framework ./"$FRAMEWORK"watchOSSim.xcarchive/Products/Library/Frameworks/"$FRAMEWORK".framework \
		-output "$FRAMEWORK"-watchOS.xcframework
	;; # Message for -watch option
 
#----- Make Mac archive
    -mac) if [ -d "./"$FRAMEWORK"-macOS.xcframework" ]; then
          rm -rf "./"$FRAMEWORK"-macOS.xcframework"
          fi
	xcodebuild archive \
	-scheme  "$FRAMEWORK" \
	-archivePath "$FRAMEWORK"macOS.xcarchive \
	-sdk macosx \
	SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES SUPPORTS_MACCATALYST=NO

echo "Creating XCFramework..."
	xcodebuild -create-xcframework \
		-framework ./"$FRAMEWORK"macOS.xcarchive/Products/Library/Frameworks/"$FRAMEWORK".framework \
		-output "$FRAMEWORK"-macOS.xcframework
	;; # Message for -mac option
 
    -tv) if [ -d "./"$FRAMEWORK"-tvOS.xcframework" ]; then
         rm -rf "./"$FRAMEWORK"-tvOS.xcframework"
         fi
	xcodebuild archive \
	-scheme  "$FRAMEWORK" \
	-sdk appletvsimulator \
	-archivePath "$FRAMEWORK"tvOSSim.xcarchive \
	SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

#----- Make tvOS device archive
	xcodebuild archive \
	-scheme  "$FRAMEWORK" \
	-archivePath "$FRAMEWORK"tvOSDev.xcarchive \
	-sdk appletvos \
	SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES 

echo "Creating XCFramework..."
	xcodebuild -create-xcframework \
		-framework ./"$FRAMEWORK"tvOSSim.xcarchive/Products/Library/Frameworks/"$FRAMEWORK".framework \
		-output "$FRAMEWORK"-tvOS.xcframework
	;; # Message for -tv option
 
    *) echo "Option $2 not recognized. Options are -mac, -iOS, -watch, -cat, -tv" ;; 
 
    esac
 
    shift

sudo xcode-select -switch /Applications/Xcode.app


echo "Cleanup..."
if [ -d "./"$FRAMEWORK"iOSSim.xcarchive" ]; then
rm -rf "./"$FRAMEWORK"iOSSim.xcarchive"
fi
if [ -d "./"$FRAMEWORK"iOSDev.xcarchive" ]; then
rm -rf "./"$FRAMEWORK"iOSDev.xcarchive"
fi
if [ -d "./"$FRAMEWORK"watchOSSim.xcarchive" ]; then
rm -rf "./"$FRAMEWORK"watchOSSim.xcarchive"
fi
if [ -d "./"$FRAMEWORK"watchOSDev.xcarchive" ]; then
rm -rf "./"$FRAMEWORK"watchOSDev.xcarchive"
fi
if [ -d "./"$FRAMEWORK"macOS.xcarchive" ]; then
rm -rf "./"$FRAMEWORK"macOS.xcarchive"
fi
if [ -d "./"$FRAMEWORK"macOSCat.xcarchive" ]; then
rm -rf "./"$FRAMEWORK"macOSCat.xcarchive"
fi
if [ -d "./"$FRAMEWORK"tvOSDev.xcarchive" ]; then
rm -rf "./"$FRAMEWORK"tvOSDev.xcarchive"
fi
if [ -d "./"$FRAMEWORK"tvOSSim.xcarchive" ]; then
rm -rf "./"$FRAMEWORK"tvOSSim.xcarchive"
fi

echo "Done."

 
done
