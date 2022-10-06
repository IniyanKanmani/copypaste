# copypaste

Cross platform copy paste application.

## Getting Started

adb -d shell appops set com.iniyan.copypaste SYSTEM_ALERT_WINDOW allow;
adb -d shell pm grant com.iniyan.copypaste android.permission.READ_LOGS;
adb shell am force-stop com.iniyan.copypaste;
