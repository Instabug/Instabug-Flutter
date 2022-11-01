package com.instabug.flutter;

import static org.mockito.Mockito.mockStatic;

import com.instabug.flutter.modules.InstabugApi;
import com.instabug.library.Instabug;

import junit.framework.TestCase;

import org.mockito.MockedStatic;


public class InstabugApiTest extends TestCase {
    private final InstabugApi mApi = new InstabugApi(null);
    private final MockedStatic<Instabug> mInstabug = mockStatic(Instabug.class);

    public void testLogOut() {
        mApi.logOut();
        mInstabug.verify(Instabug::logoutUser);
    }
}