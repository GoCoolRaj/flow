#!/bin/bash

# Exit on error
set -e

# Function to display usage instructions
usage() {
  echo "Usage: $0 -f <flavor> -b <build_type> -p <platform> [-t <package_type>] -a <action>"
  echo ""
  echo "Options:"
  echo "  -f   Flavor (staging, demo, prod)"
  echo "  -b   Build type (debug, profile, release)"
  echo "  -p   Platform (android, ios)"
  echo "  -t   Package type for Android (apk, appbundle) [Optional, defaults to apk]"
  echo "  -a   Action (build or run)"
  echo ""
  echo "Examples:"
  echo "  $0 -f staging -b release -p android -t appbundle -a build"
  echo "  $0 -f prod -b debug -p ios -a run"
  exit 1
}

# Parse input arguments
while getopts "f:b:p:t:a:" opt; do
  case ${opt} in
    f) FLAVOR=$OPTARG ;;
    b) BUILD_TYPE=$OPTARG ;;
    p) PLATFORM=$OPTARG ;;
    t) PACKAGE_TYPE=$OPTARG ;;
    a) ACTION=$OPTARG ;;
    *) usage ;;
  esac
done

# Validate required arguments
if [[ -z "$FLAVOR" || -z "$BUILD_TYPE" || -z "$PLATFORM" || -z "$ACTION" ]]; then
  usage
fi

# Default package type for Android
if [[ "$PLATFORM" == "android" && -z "$PACKAGE_TYPE" ]]; then
  PACKAGE_TYPE="apk"
fi

# Validate inputs
if [[ ! "$FLAVOR" =~ ^(staging|demo|prod)$ ]]; then
  echo "Error: Invalid flavor. Must be one of: staging, demo, prod."
  exit 1
fi

if [[ ! "$BUILD_TYPE" =~ ^(debug|profile|release)$ ]]; then
  echo "Error: Invalid build type. Must be one of: debug, profile, release."
  exit 1
fi

if [[ ! "$PLATFORM" =~ ^(android|ios)$ ]]; then
  echo "Error: Invalid platform. Must be one of: android, ios."
  exit 1
fi

if [[ ! "$ACTION" =~ ^(build|run)$ ]]; then
  echo "Error: Invalid action. Must be one of: build, run."
  exit 1
fi

if [[ "$PLATFORM" == "android" && ! "$PACKAGE_TYPE" =~ ^(apk|appbundle)$ ]]; then
  echo "Error: Invalid package type for Android. Must be one of: apk, appbundle."
  exit 1
fi

# Define target file based on flavor
TARGET_FILE="lib/main_${FLAVOR}.dart"

# iOS scheme & GoogleService-Info path derived from flavor (controls archive folder name)
IOS_SCHEME="Quilt"            # default for prod
GSP_PATH="ios/config/prod/GoogleService-Info.plist"
case "$FLAVOR" in
  demo)
    IOS_SCHEME="Quilt Demo"
    GSP_PATH="ios/config/demo/GoogleService-Info.plist"
    ;;
  staging)
    IOS_SCHEME="Quilt Staging"   # Adjust if your scheme is named differently
    GSP_PATH="ios/config/staging/GoogleService-Info.plist"
    ;;
  prod)
    IOS_SCHEME="Quilt"
    GSP_PATH="ios/config/prod/GoogleService-Info.plist"
    ;;
  *) ;;
esac

# Xcode names the archive folder after the scheme/product name, so dSYMs live under:
#   build/ios/archive/<SCHEME>.xcarchive/dSYMs
ARCHIVE_DIR="build/ios/archive"
XCARCHIVE_PATH="${ARCHIVE_DIR}/${IOS_SCHEME}.xcarchive"

upload_ios_dsyms() {
  local upload_bin="ios/Pods/FirebaseCrashlytics/upload-symbols"
  if [[ ! -f "$upload_bin" ]]; then
    echo "⚠️  Crashlytics upload-symbols not found at $upload_bin"
    return 0
  fi
  chmod +x "$upload_bin"

  # If the exact scheme archive doesn't exist, try to pick the most recent matching archive
  if [[ ! -d "$XCARCHIVE_PATH" ]]; then
    echo "ℹ️  Archive not found at '$XCARCHIVE_PATH'. Trying to locate a recent archive for scheme '$IOS_SCHEME'..."
    XCARCHIVE_PATH=$(ls -dt "${ARCHIVE_DIR}/${IOS_SCHEME}.xcarchive" "${ARCHIVE_DIR}/${IOS_SCHEME}"*.xcarchive 2>/dev/null | head -n1 || true)
  fi

  if [[ -z "$XCARCHIVE_PATH" || ! -d "$XCARCHIVE_PATH" ]]; then
    echo "❌ Could not find an .xcarchive for scheme '$IOS_SCHEME' in ${ARCHIVE_DIR}. Skipping dSYM upload."
    return 0
  fi

  local dsyms_dir="${XCARCHIVE_PATH}/dSYMs"
  echo "📦 Using archive: $XCARCHIVE_PATH"
  echo "📄 Using GSP: $GSP_PATH"
  echo "⬆️  Uploading dSYMs from: $dsyms_dir"

  "$upload_bin" -gsp "$GSP_PATH" -p ios "$dsyms_dir"
  echo "✅ Crashlytics dSYM upload complete for scheme '$IOS_SCHEME' (flavor: $FLAVOR)"
}

# Build or run logic
echo "$ACTION $PLATFORM app for flavor: $FLAVOR, build type: $BUILD_TYPE"

if [[ "$PLATFORM" == "android" ]]; then
  if [[ "$ACTION" == "build" ]]; then
    if [[ "$PACKAGE_TYPE" == "apk" ]]; then
      echo "Building Android APK..."
      flutter build apk --flavor $FLAVOR -t $TARGET_FILE --dart-define=FLAVOR=$FLAVOR --$BUILD_TYPE
    else
      echo "Building Android App Bundle..."
      flutter build appbundle --flavor $FLAVOR -t $TARGET_FILE --dart-define=FLAVOR=$FLAVOR --$BUILD_TYPE
    fi
  elif [[ "$ACTION" == "run" ]]; then
    if [[ "$PACKAGE_TYPE" == "apk" ]]; then
      echo "Running Android APK..."
      flutter run --flavor $FLAVOR -t $TARGET_FILE --dart-define=FLAVOR=$FLAVOR --$BUILD_TYPE
    else
      echo "Running Android App Bundle..."
      flutter run --flavor $FLAVOR -t $TARGET_FILE --dart-define=FLAVOR=$FLAVOR --$BUILD_TYPE --release
    fi
  fi
elif [[ "$PLATFORM" == "ios" ]]; then
  if [[ "$ACTION" == "build" ]]; then
    echo "Building iOS IPA..."
    flutter build ipa --flavor $FLAVOR -t $TARGET_FILE --dart-define=FLAVOR=$FLAVOR --$BUILD_TYPE
    # Automatically upload dSYMs to Crashlytics for the built archive
    upload_ios_dsyms
  elif [[ "$ACTION" == "run" ]]; then
    echo "Running iOS app..."
    flutter run --flavor $FLAVOR -t $TARGET_FILE --dart-define=FLAVOR=$FLAVOR --$BUILD_TYPE
  fi
fi

echo "$ACTION completed successfully!"