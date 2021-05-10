package com.vvs.task.task_app_for_daniel;

import io.flutter.embedding.android.FlutterActivity

import android.os.Bundle;
import io.flutter.plugins.androidalarmmanager.AndroidAlarmManagerPlugin;

class MainActivity: FlutterActivity() {
    val TAG = "MainActivity"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
//        AndroidAlarmManagerPlugin.registerWith(
//            registrarFor("io.flutter.plugins.androidalarmmanager.AndroidAlarmManagerPlugin")
//        )
    }
}
