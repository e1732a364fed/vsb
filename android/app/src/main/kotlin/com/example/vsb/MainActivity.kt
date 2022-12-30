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
    private val CHANNEL = "samples.flutter.dev/battery"

     var dialConfStr = ""


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
      call, result ->
      // This method is invoked on the main thread.
      // TODO

      when (call.method) {
        "getBatteryLevel" -> {
            result.success(3)
        }
          "setDialConfStr"->{

              dialConfStr = (call.argument("text") as? String).toString();
              Log.w("vss",dialConfStr)

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
               Log.w("shit","no permission")
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
