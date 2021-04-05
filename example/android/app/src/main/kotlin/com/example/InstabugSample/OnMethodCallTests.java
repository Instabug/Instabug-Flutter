package com.example.InstabugSample;

import com.instabug.instabugflutter.InstabugFlutterPlugin;

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
            public void success(Object o) {
            }
            @Override
            public void error(String s, String s1, Object o) {
            }
            @Override
            public void notImplemented() {
            }
        };
        instabugMock.onMethodCall(methodCall,result);
    }

    public void testShowWelcomeMessageWithMode() {
        String methodName = "showWelcomeMessageWithMode";
        ArrayList<Object> argsList = new ArrayList<>();
        argsList.add("WelcomeMessageMode.live");
        Mockito.doNothing().when(instabugMock).showWelcomeMessageWithMode(any(String.class));
        testMethodCall(methodName,argsList);
        verify(instabugMock).showWelcomeMessageWithMode("WelcomeMessageMode.live");
    }

    public void testIdentifyUserWithEmail() {
        String methodName = "identifyUserWithEmail";
        ArrayList<Object> argsList = new ArrayList<>();
        argsList.add("aly@gmail.com");
        argsList.add("Aly");
        Mockito.doNothing().when(instabugMock).identifyUserWithEmail(any(String.class),any(String.class));
        testMethodCall(methodName,argsList);
        verify(instabugMock).identifyUserWithEmail("aly@gmail.com","Aly");
    }

    public void testLogOut() {
        String methodName = "logOut";
        Mockito.doNothing().when(instabugMock).logOut();
        testMethodCall(methodName,null);
        verify(instabugMock).logOut();
    }

    public void testAppendTags() {
        String methodName = "appendTags";
        ArrayList<Object> argsList = new ArrayList<>();
        ArrayList<String> tags = new ArrayList<>();
        tags.add("tag1");
        tags.add("tag2");
        argsList.add(tags);
        Mockito.doNothing().when(instabugMock).appendTags(any(ArrayList.class));
        testMethodCall(methodName,argsList);
        verify(instabugMock).appendTags(tags);
    }

    public void testShowBugReportingWithReportTypeAndOptions() {
        String methodName = "showBugReportingWithReportTypeAndOptions";
        ArrayList<Object> argsList = new ArrayList<>();
        ArrayList<String> options = new ArrayList<>();
        options.add("commentFieldRequired");
        options.add("disablePostSendingDialog");
        argsList.add("bug");
        argsList.add(options);
        Mockito.doNothing().when(instabugMock).showBugReportingWithReportTypeAndOptions(any(String.class),any(ArrayList.class));
        testMethodCall(methodName,argsList);
        verify(instabugMock).showBugReportingWithReportTypeAndOptions("bug", options);
    }

    public void testSetSessionProfilerEnabled() {
        String methodName = "setSessionProfilerEnabled";
        ArrayList<Object> argsList = new ArrayList<>();
        argsList.add(true);
        Mockito.doNothing().when(instabugMock).setSessionProfilerEnabled(any(Boolean.class));
        testMethodCall(methodName,argsList);
        verify(instabugMock).setSessionProfilerEnabled(true);
    }

    public void testSetDebugEnabled() {
        String methodName = "setDebugEnabled";
        ArrayList<Object> argsList = new ArrayList<>();
        argsList.add(true);
        Mockito.doNothing().when(instabugMock).setDebugEnabled(any(Boolean.class));
        testMethodCall(methodName,argsList);
        verify(instabugMock).setDebugEnabled(true);
    }

    public void testSetPrimaryColor() {
        String methodName = "setPrimaryColor";
        ArrayList<Object> argsList = new ArrayList<>();
        argsList.add(12312331231233L);
        Mockito.doNothing().when(instabugMock).setPrimaryColor(any(Long.class));
        testMethodCall(methodName,argsList);
        verify(instabugMock).setPrimaryColor(12312331231233L);
    }

    public void testAddFileAttachmentWithData() {
        String methodName = "addFileAttachmentWithData";
        ArrayList<Object> argsList = new ArrayList<>();
        String string = "myfile";
        argsList.add(string.getBytes());
        argsList.add(string);
        Mockito.doNothing().when(instabugMock).addFileAttachmentWithData(any(byte[].class), any(String.class));
        testMethodCall(methodName,argsList);
        verify(instabugMock).addFileAttachmentWithData(string.getBytes(), string);
    }

    public void testSetEnabledAttachmentTypes() {
        String methodName = "setEnabledAttachmentTypes";
        ArrayList<Object> argsList = new ArrayList<>();
        argsList.add(true);
        argsList.add(true);
        argsList.add(true);
        argsList.add(true);
        Mockito.doNothing().when(instabugMock).setEnabledAttachmentTypes(any(Boolean.class),any(Boolean.class),any(Boolean.class),any(Boolean.class));
        testMethodCall(methodName,argsList);
        verify(instabugMock).setEnabledAttachmentTypes(true,true,true,true);
    }

    public void testSetEmailFieldRequiredForFeatureRequests() {
        String methodName = "setEmailFieldRequiredForFeatureRequests";
        ArrayList<Object> argsList = new ArrayList<>();
        ArrayList<String> actions = new ArrayList<>();
        actions.add("reportBug");
        actions.add("requestNewFeature");
        argsList.add(true);
        argsList.add(actions);
        Mockito.doNothing().when(instabugMock).setEmailFieldRequiredForFeatureRequests(any(Boolean.class),any(ArrayList.class));
        testMethodCall(methodName,argsList);
        verify(instabugMock).setEmailFieldRequiredForFeatureRequests(true,actions);
    }


}
