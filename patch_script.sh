#!/bin/bash

# 1. Inject MemoryManagerService.java
cp MemoryManagerService.java app/src/main/java/com/winlator/MemoryManagerService.java

# Register Service in AndroidManifest.xml
sed -i '/<activity/i \        <service android:name=".MemoryManagerService" android:enabled="true" android:exported="false" />' app/src/main/AndroidManifest.xml

# Start Service in MainActivity.java
sed -i '/super.onCreate(savedInstanceState);/a \        Intent intent = new Intent(this, MemoryManagerService.class);\n        startService(intent);' app/src/main/java/com/winlator/MainActivity.java
# Add import for Intent
sed -i '/package com.winlator;/a import android.content.Intent;' app/src/main/java/com/winlator/MainActivity.java

# 2. Thermal Throttling in XServerDisplayActivity.java (Winlator's GameActivity equivalent)
# Add imports
sed -i '/import android.os.Bundle;/a import android.os.BatteryManager;\nimport android.content.IntentFilter;' app/src/main/java/com/winlator/XServerDisplayActivity.java

# Add checkThermalThrottling method before the end of the class
sed -i '$i \    private void checkThermalThrottling() {\n        IntentFilter ifilter = new IntentFilter(Intent.ACTION_BATTERY_CHANGED);\n        Intent batteryStatus = registerReceiver(null, ifilter);\n        if (batteryStatus != null) {\n            int temp = batteryStatus.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, 0);\n            if (temp > 400) {\n                Log.d("ThermalThrottling", "Temperature high (" + temp + "), limiting FPS to 30");\n                envVars.put("DXVK_FRAME_RATE", "30");\n            }\n        }\n    }' app/src/main/java/com/winlator/XServerDisplayActivity.java

# Call checkThermalThrottling in onResume
sed -i '/@Override/i \    @Override\n    protected void onResume() {\n        super.onResume();\n        checkThermalThrottling();\n    }' app/src/main/java/com/winlator/XServerDisplayActivity.java

# 3. Adreno 630 Fix: Download Turnip Driver
mkdir -p app/src/main/assets/dxwrapper
wget -O turnip_r18.zip https://github.com/K11MCH1/AdrenoToolsDrivers/releases/download/v24.1.0_R18/turnip-24.1.0_R18.zip
unzip turnip_r18.zip -d app/src/main/assets/dxwrapper/default_driver

# 4. UI Theme: Overwrite colors.xml
cp colors.xml app/src/main/res/values/colors.xml
