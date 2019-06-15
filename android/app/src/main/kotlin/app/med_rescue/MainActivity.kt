package app.med_rescue

import android.Manifest
import android.os.Bundle
import android.widget.Toast

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import android.Manifest.permission
import android.Manifest.permission.CALL_PHONE
import android.content.pm.PackageManager
import android.net.Uri
import android.content.Intent
import android.os.Build
import android.view.View
import android.util.Log
import androidx.core.app.ActivityCompat


class MainActivity: FlutterActivity() {
  private val CHANNEL = "app.med_rescue/callChannel"
  private var number: String? = null


  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)
    MethodChannel(flutterView, CHANNEL).setMethodCallHandler { call, result ->
      if (call.method == "makeCall") {
        if (call.hasArgument("number")) {
          /*Toast.makeText(this, "Number => ${call.argument<String>("number")}",
                  Toast.LENGTH_LONG).show()*/
          number = call.argument<String>("number")
          if(number == null || number!!.isEmpty()){
            result.success(false)
          }else{
            if(!isPermissionGranted()){
              ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.CALL_PHONE), 1)
            }else{
              result.success(makeCall(number!!))
            }
          }
          /*val batteryLevel = getBatteryLevel()
}
        if (batteryLevel != -1) {
          result.success(batteryLevel)
        } else {
          result.error("UNAVAILABLE", "Battery level not available.", null)
        }*/
        } else {
          result.notImplemented()
        }
      }else if(call.method == "requestPermission"){
        if(!isPermissionGranted()){
          ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.CALL_PHONE), 1)
        }
      }
    }
  }

  fun makeCall(number: String): Boolean{
    if(isPermissionGranted()){
//      Toast.makeText(this, "Number => $number",
//              Toast.LENGTH_LONG).show()
      val callIntent = Intent(Intent.ACTION_CALL) //use ACTION_CALL class
      callIntent.data = Uri.parse("tel:$number")
//      val callIntent = Intent(Intent.ACTION_CALL)
//      callIntent.data = Uri.parse("tel:123456789")
      startActivity(callIntent)
      return true
    }else{
      Toast.makeText(this, "Permission not granted",
              Toast.LENGTH_LONG).show()
      return false
    }
  }

  fun isPermissionGranted(): Boolean {
    if (Build.VERSION.SDK_INT >= 23) {
      if (checkSelfPermission(android.Manifest.permission.CALL_PHONE) == PackageManager.PERMISSION_GRANTED) {
        Log.v("TAG", "Permission is granted")
        return true
      } else {
        Log.v("TAG", "Permission is revoked")

        ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.CALL_PHONE), 1)
        return false
      }
    } else { //permission is automatically granted on sdk<23 upon installation
      Log.v("TAG", "Permission is granted")
      return true
    }
  }


  override fun onRequestPermissionsResult(requestCode: Int,
                                          permissions: Array<String>, grantResults: IntArray) {
    when (requestCode) {
      1 -> {
        if (grantResults.size > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
          Toast.makeText(applicationContext, "Permission granted", Toast.LENGTH_SHORT).show()
          makeCall(number!!)
//          call_action()
        } else {
          Toast.makeText(applicationContext, "Permission denied", Toast.LENGTH_SHORT).show()
        }
        return
      }
    }// other 'case' lines to check for other
    // permissions this app might request
  }
}
