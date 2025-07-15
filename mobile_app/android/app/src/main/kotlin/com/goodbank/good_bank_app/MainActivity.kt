package com.goodbank.good_bank_app

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "smartscanner_mrz"
    private val REQUEST_CODE_MRZ = 1001
    
    private var pendingResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "scanMRZ" -> {
                    pendingResult = result
                    startMRZScan()
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun startMRZScan() {
        try {
            val intent = Intent("org.idpass.smartscanner.MRZ_SCAN")
            startActivityForResult(intent, REQUEST_CODE_MRZ)
        } catch (ex: ActivityNotFoundException) {
            // SmartScanner not installed, return error
            pendingResult?.error("SCANNER_NOT_AVAILABLE", "SmartScanner app not installed", null)
            pendingResult = null
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        
        if (requestCode == REQUEST_CODE_MRZ) {
            if (resultCode == Activity.RESULT_OK && data != null) {
                val bundle = data.getBundleExtra("result")
                if (bundle != null) {
                    // Convert Bundle to Map for Flutter
                    val resultMap = mutableMapOf<String, Any?>()
                    
                    // Extract MRZ data fields
                    resultMap["surname"] = bundle.getString("surname")
                    resultMap["givenNames"] = bundle.getString("givenNames")
                    resultMap["documentNumber"] = bundle.getString("documentNumber")
                    resultMap["issuingCountry"] = bundle.getString("issuingCountry")
                    resultMap["nationality"] = bundle.getString("nationality")
                    resultMap["dateOfBirth"] = bundle.getString("dateOfBirth")
                    resultMap["sex"] = bundle.getString("sex")
                    resultMap["dateOfExpiry"] = bundle.getString("dateOfExpiry")
                    resultMap["personalNumber"] = bundle.getString("personalNumber")
                    
                    pendingResult?.success(resultMap)
                } else {
                    pendingResult?.error("SCAN_ERROR", "No scan data received", null)
                }
            } else {
                pendingResult?.error("SCAN_CANCELLED", "Scan was cancelled", null)
            }
            pendingResult = null
        }
    }
}
