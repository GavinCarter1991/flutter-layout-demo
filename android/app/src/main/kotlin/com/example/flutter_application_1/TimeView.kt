package com.example.platformviewdemo;

import android.content.Context;
import android.graphics.Color;
import android.view.View;
import android.widget.TextView;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.Map;

class TimeView implements PlatformView, MethodChannel.MethodCallHandler {
    private final TextView textView;
    private final MethodChannel methodChannel;

    TimeView(Context context, BinaryMessenger messenger, int id, Map<String, Object> params) {
        textView = new TextView(context);
        
        // 解析Flutter传递的参数
        if (params != null && params.containsKey("textColor")) {
            String color = (String) params.get("textColor");
            textView.setTextColor(Color.parseColor(color));
        } else {
            textView.setTextColor(Color.BLUE);
        }
        
        textView.setTextSize(20);
        textView.setText("Android原生时间视图");
        
        // 创建方法通道
        methodChannel = new MethodChannel(messenger, "com.example/time_channel");
        methodChannel.setMethodCallHandler(this);
    }

    @Override
    public View getView() {
        return textView;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        if (call.method.equals("getCurrentTime")) {
            // 返回当前时间给Flutter
            SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss", Locale.getDefault());
            result.success(sdf.format(new Date()));
        } else {
            result.notImplemented();
        }
    }

    @Override
    public void dispose() {
        methodChannel.setMethodCallHandler(null);
    }
}