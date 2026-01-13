package com.winlator;

import android.app.Service;
import android.content.ComponentCallbacks2;
import android.content.Intent;
import android.os.Handler;
import android.os.IBinder;
import android.util.Log;

public class MemoryManagerService extends Service {
    private static final String TAG = "MemoryManagerService";
    private final Handler handler = new Handler();
    private final Runnable memoryCleanupTask = new Runnable() {
        @Override
        public void run() {
            Log.d(TAG, "Running scheduled memory cleanup...");
            System.gc();
            onTrimMemory(ComponentCallbacks2.TRIM_MEMORY_RUNNING_CRITICAL);
            handler.postDelayed(this, 60000); // Run every 60 seconds
        }
    };

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        Log.d(TAG, "Service started");
        handler.post(memoryCleanupTask);
        return START_STICKY;
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        handler.removeCallbacks(memoryCleanupTask);
        Log.d(TAG, "Service destroyed");
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }
}
