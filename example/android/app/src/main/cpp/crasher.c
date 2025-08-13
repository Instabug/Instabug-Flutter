
#include <jni.h>
#include <sys/user.h>
#include <unistd.h>
#include <stdlib.h>
#include "crasher_2.h"

/************* SIGSEGV *******************************/
JNIEXPORT void JNICALL
Java_com_example_InstabugSample_ndk_CppNativeLib_causeSIGSEGVCrash(JNIEnv *env, jobject thiz) {
    causeSIGSEGVCrashF1();
}

/*****************************************************/

/************* SIGABRT *******************************/
JNIEXPORT void JNICALL
Java_com_example_InstabugSample_ndk_CppNativeLib_causeSIGABRTCrash(JNIEnv *env, jobject thiz) {
    causeSIGABRTCrashF1();
}
/****************************************************/

/************* SIGFPE *******************************/
JNIEXPORT void JNICALL
Java_com_example_InstabugSample_ndk_CppNativeLib_causeSIGFPECrash(JNIEnv *env, jobject thiz) {
    causeSIGFPECrashF1();
}
/***************************************************/

/************* SIGILL *******************************/

JNIEXPORT void JNICALL
Java_com_example_InstabugSample_ndk_CppNativeLib_causeSIGILLCrash(JNIEnv *env, jobject thiz) {
    causeSIGILLCrashF1();
}
/***************************************************/

/************* SIGBUS *******************************/
JNIEXPORT void JNICALL
Java_com_example_InstabugSample_ndk_CppNativeLib_causeSIGBUSCrash(JNIEnv *env, jobject thiz) {
    causeSIGBUSCrashF1();
}
/***************************************************/

/************* SIGTRAP *******************************/
JNIEXPORT void JNICALL
Java_com_example_InstabugSample_ndk_CppNativeLib_causeSIGTRAPCrash(JNIEnv *env, jobject thiz) {
    causeSIGTRAPCrashF1();
}
/***************************************************/
