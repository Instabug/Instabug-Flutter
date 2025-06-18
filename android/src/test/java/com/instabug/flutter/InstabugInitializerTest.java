package com.instabug.flutter;

import static com.instabug.flutter.util.GlobalMocks.reflected;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.mockStatic;
import static org.mockito.Mockito.spy;

import com.instabug.flutter.modules.InstabugInitializer;
import com.instabug.flutter.util.GlobalMocks;
import com.instabug.flutter.util.MockReflected;
import com.instabug.library.Instabug;
import com.instabug.library.Platform;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.mockito.MockedStatic;

import io.flutter.plugin.common.BinaryMessenger;

public class InstabugInitializerTest {
    private InstabugInitializer api;
    private MockedStatic<Instabug> mInstabug;

    @Before
    public void setUp() throws NoSuchMethodException {

        BinaryMessenger mMessenger = mock(BinaryMessenger.class);
        api = spy(InstabugInitializer.getInstance());
        mInstabug = mockStatic(Instabug.class);
        GlobalMocks.setUp();
    }

    @After
    public void cleanUp() {
        mInstabug.close();
        GlobalMocks.close();

    }

    @Test
    public void testSetCurrentPlatform() {
        api.setCurrentPlatform();

        reflected.verify(() -> MockReflected.setCurrentPlatform(Platform.FLUTTER));
    }
}
