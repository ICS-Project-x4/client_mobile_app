#!/bin/bash

# Remplacez par l'IP de votre téléphone
PHONE_IP="10.0.23.27"
PORT="5555"

echo "🔌 Connecting to phone via WiFi..."
adb connect $PHONE_IP:$PORT

echo "📱 Checking connection..."
adb devices

echo "🚀 Launching Flutter app..."
flutter run