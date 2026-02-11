#!/bin/bash

echo "Running flutter clean..."
flutter clean

echo "Cleaning flutter pub cache..."
flutter pub cache clean -f

echo "Running flutter pub get..."
flutter pub get

echo "Navigating to iOS directory and running pod install..."
cd ios
pod install
cd ..

echo "All tasks completed successfully!"