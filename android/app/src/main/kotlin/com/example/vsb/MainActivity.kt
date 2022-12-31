package com.example.vsb

import io.flutter.embedding.android.FlutterActivity

import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Intent
import android.net.Uri
import android.util.Log
import android.net.VpnService


class MainActivity: FlutterActivity() {
    private val CHANNEL = "vsb.e1732a364fed.github/channel1"

    var dialConfStr = ""

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
      call, result ->

      when (call.method) {
        // "getBatteryLevel" -> {
        //     result.success(3)
        // }
          "setDialConfStr"->{

              dialConfStr = (call.argument("text") as? String).toString();
              Log.w("vs, set dialConfStr",dialConfStr)

              result.success(0)

          }

        "start" -> {

            val service1 = Runnable {

                Log.w("vs", "starting 1")
                var intent = Intent(this, MyVpnService::class.java)
                intent.putExtra("dialConfStr", dialConfStr);
                startService(intent)
            }

            val intent = VpnService.prepare(this)
            if (intent != null) {
               Log.w("vshit","no permission, try get.")
                startActivityForResult(intent,0)
            } else {
                service1.run()
            }

            result.success(0)
        }
    }


    }
  }

    
}
