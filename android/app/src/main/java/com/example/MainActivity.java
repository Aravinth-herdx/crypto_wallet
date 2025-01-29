package com.your_package_name;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import android.os.Bundle;
import android.provider.Settings;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "device_info";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        new MethodChannel(getFlutterEngine().getDartExecutor(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("getAndroidDeviceId")) {
                                String androidId = Settings.Secure.getString(getContentResolver(), Settings.Secure.ANDROID_ID);
                                result.success(androidId);
                            } else {
                                result.notImplemented();
                            }
                        }
                );
    }
}
