package com.instabug.instabugflutter;

import org.junit.Test;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;


public class InstabugFlutterPluginTest {

    @Test
    public void testShowWelcomeMessageWithMode() {
        new OnMethodCallTests().testShowWelcomeMessageWithMode();
    }
}
