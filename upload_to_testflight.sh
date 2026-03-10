#!/bin/bash
# Uploads the built IPA to App Store Connect (TestFlight) using xcrun altool

# Replace these variables with your actual credentials, or pass them as environment variables
APPLE_ID="${APPLE_ID:-your_email@apple.com}"
APP_PASSWORD="${APP_PASSWORD:-your-app-specific-password}"

IPA_PATH=$(find build/ios/ipa -name "*.ipa" | head -n 1)

if [ -z "$IPA_PATH" ]; then
    echo "❌ No IPA found in build/ios/ipa/. Please run 'flutter build ipa --dart-define-from-file=.env' first."
    exit 1
fi

echo "🚀 Uploading $IPA_PATH to App Store Connect..."
xcrun altool --upload-app -f "$IPA_PATH" -t ios -u "$APPLE_ID" -p "$APP_PASSWORD" --verbose

if [ $? -eq 0 ]; then
    echo "✅ Upload successful! The build should appear in TestFlight shortly."
else
    echo "❌ Upload failed. Check the error above."
fi
