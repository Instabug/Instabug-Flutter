package com.example.InstabugSample
import android.os.Handler
import android.os.Looper
import android.util.Log
import com.example.InstabugSample.nativeLibs.CppNativeLib
import com.instabug.crash.CrashReporting
import com.instabug.crash.models.IBGNonFatalException
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class InstabugExampleMethodCallHandler : MethodChannel.MethodCallHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            SEND_NATIVE_NON_FATAL_CRASH -> {
                Log.d(TAG, "Sending native non-fatal crash from Android")
                val exceptionObject = call.arguments as? String
                sendNativeNonFatal(exceptionObject)
                result.success(null)
            }
            SEND_NATIVE_FATAL_CRASH -> {
                Log.d(TAG, "Sending native fatal crash from Android")
                sendNativeFatalCrash()
                result.success(null)
            }
            SEND_NATIVE_FATAL_HANG -> {
                Log.d(TAG, "Sending native fatal hang for 3000 ms")
                sendANR()
                result.success(null)
            }
            SEND_ANR -> {
                Log.d(TAG, "Sending android not responding 'ANR' hanging for 20000 ms")
                sendFatalHang()
                result.success(null)
            }
            SEND_OOM -> {
                Log.d(TAG, "sending out of memory")
                sendOOM()
                result.success(null)
            }
            CAUSE_NDK_CRASH -> {
                Log.d(TAG, "Causing NDK crash")
                causeNdkCrash()
                result.success(null)
            }
            CAUSE_SIGSEGV_CRASH -> {
                Log.d(TAG, "Causing SIGSEGV crash")
                causeSIGSEGVCrash()
                result.success(null)
            }
            CAUSE_SIGABRT_CRASH -> {
                Log.d(TAG, "Causing SIGABRT crash")
                causeSIGABRTCrash()
                result.success(null)
            }
            CAUSE_SIGFPE_CRASH -> {
                Log.d(TAG, "Causing SIGFPE crash")
                causeSIGFPECrash()
                result.success(null)
            }
            CAUSE_SIGILL_CRASH -> {
                Log.d(TAG, "Causing SIGILL crash")
                causeSIGILLCrash()
                result.success(null)
            }
            CAUSE_SIGBUS_CRASH -> {
                Log.d(TAG, "Causing SIGBUS crash")
                causeSIGBUSCrash()
                result.success(null)
            }
            CAUSE_SIGTRAP_CRASH -> {
                Log.d(TAG, "Causing SIGTRAP crash")
                causeSIGTRAPCrash()
                result.success(null)
            }
            else -> {
                Log.e(TAG, "onMethodCall for ${call.method} is not implemented")
                result.notImplemented()
            }
        }
    }

    companion object {
        const val TAG = "IBGEMethodCallHandler";

        const val METHOD_CHANNEL_NAME = "instabug_flutter_example"

        // Method Names
        const val SEND_NATIVE_NON_FATAL_CRASH = "sendNativeNonFatalCrash"
        const val SEND_NATIVE_FATAL_CRASH = "sendNativeFatalCrash"
        const val SEND_NATIVE_FATAL_HANG = "sendNativeFatalHang"
        const val SEND_ANR = "sendAnr"
        const val SEND_OOM = "sendOom"

        // NDK Crash Method Names
        const val CAUSE_NDK_CRASH = "causeNdkCrash"
        const val CAUSE_SIGSEGV_CRASH = "causeSIGSEGVCrash"
        const val CAUSE_SIGABRT_CRASH = "causeSIGABRTCrash"
        const val CAUSE_SIGFPE_CRASH = "causeSIGFPECrash"
        const val CAUSE_SIGILL_CRASH = "causeSIGILLCrash"
        const val CAUSE_SIGBUS_CRASH = "causeSIGBUSCrash"
        const val CAUSE_SIGTRAP_CRASH = "causeSIGTRAPCrash"
    }

    private fun sendNativeNonFatal(exceptionObject: String?) {
        val exception: IBGNonFatalException = IBGNonFatalException.Builder(IllegalStateException("Test exception"))
                .build()
        CrashReporting.report(exception)
    }

    private fun sendNativeFatalCrash() {
        Handler(Looper.getMainLooper()).post {
            throw IllegalStateException("Unhandled IllegalStateException from Instabug Test App")

        }
    }

    private fun sendANR() {
        try {
            Thread.sleep(20000)
        } catch (e: InterruptedException) {
            throw RuntimeException(e)
        }
    }

    private fun sendFatalHang() {
        try {
            Thread.sleep(3000)
        } catch (e: InterruptedException) {
            throw RuntimeException(e)
        }
    }

    private fun sendOOM() {
        oomCrash()
    }

    private fun oomCrash() {
        Thread {
            val stringList: MutableList<String> = ArrayList()
            for (i in 0 until 1000000) {
                stringList.add(getRandomString(10000))
            }
        }.start()
    }

    private fun getRandomString(length: Int): String {
        val charset: MutableList<Char> = ArrayList()
        var ch = 'a'
        while (ch <= 'z') {
            charset.add(ch)
            ch++
        }
        ch = 'A'
        while (ch <= 'Z') {
            charset.add(ch)
            ch++
        }
        ch = '0'
        while (ch <= '9') {
            charset.add(ch)
            ch++
        }
        val randomString = StringBuilder()
        val random = java.util.Random()
        for (i in 0 until length) {
            val randomChar = charset[random.nextInt(charset.size)]
            randomString.append(randomChar)
        }
        return randomString.toString()
    }

    // NDK Crash Methods
    private fun causeNdkCrash() {
        CppNativeLib.crashNDK();
    }

    private fun causeSIGSEGVCrash() {
        CppNativeLib.causeSIGSEGVCrash();
    }

    private fun causeSIGABRTCrash() {
        CppNativeLib.causeSIGABRTCrash();
    }

    private fun causeSIGFPECrash() {
        CppNativeLib.causeSIGFPECrash();
    }

    private fun causeSIGILLCrash() {
        CppNativeLib.causeSIGILLCrash();
    }

    private fun causeSIGBUSCrash() {
        CppNativeLib.causeSIGBUSCrash();
    }

    private fun causeSIGTRAPCrash() {
        CppNativeLib.causeSIGTRAPCrash();
    }

}
