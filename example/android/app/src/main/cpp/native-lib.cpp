#include <jni.h>
#include <string>
#include <android/log.h>




/*
 * Throws invalid argument exception
 */
extern "C"
JNIEXPORT void JNICALL
Java_com_example_InstabugSample_nativeLibs_CppNativeLib_crashNDK(JNIEnv *env, jclass clazz) {
    __android_log_print(ANDROID_LOG_DEBUG, "NativeC++", "%s", "received invalid value");

    // in Android SDK it's equivalent to causeSIGABRTCrash()
    throw std::invalid_argument("received invalid value");
}