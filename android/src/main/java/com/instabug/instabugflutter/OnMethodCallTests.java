package com.instabug.instabugflutter;

import android.support.annotation.Nullable;

import org.mockito.Mockito;
import org.mockito.Spy;

import java.util.ArrayList;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.Result;

import static org.mockito.Matchers.any;
import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.verify;

 class OnMethodCallTests {

    @Spy
    private InstabugFlutterPlugin instabugMock;

     OnMethodCallTests() {
        instabugMock = spy(new InstabugFlutterPlugin());
    }

     private void testMethodCall(final String methodName, final Object params) {
        final MethodCall methodCall = new MethodCall(methodName, params);
        final Result result  = new Result() {
            @Override
            public void success(@Nullable Object o) {
            }
            @Override
            public void error(String s, @Nullable String s1, @Nullable Object o) {
            }
            @Override
            public void notImplemented() {
            }
        };
        instabugMock.onMethodCall(methodCall,result);
    }

    void testShowWelcomeMessageWithMode() {
        String methodName = "showWelcomeMessageWithMode";
        ArrayList<Object> argsList = new ArrayList<>();
        argsList.add("WelcomeMessageMode.live");
        Mockito.doNothing().when(instabugMock).showWelcomeMessageWithMode(any(String.class));
        testMethodCall(methodName,argsList);
        verify(instabugMock).showWelcomeMessageWithMode("WelcomeMessageMode.live");
    }
}
