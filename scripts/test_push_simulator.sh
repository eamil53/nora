#!/bin/bash
# Nora iOS Simulator Push Notification Test Script
# Usage: ./scripts/test_push_simulator.sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
APNS_FILE="$DIR/sample_notification.apns"

echo "📱 Booted iOS Simulator'a push bildirim gönderiliyor..."
xcrun simctl push booted com.kumaribirak.nora "$APNS_FILE"

if [ $? -eq 0 ]; then
  echo "✅ Bildirim başarıyla simülatöre iletildi!"
else
  echo "❌ Simülatör bulunamadı veya bildirim gönderilemedi. Lütfen bir iOS simülatörünün açık (Booted) olduğundan emin olun."
fi
