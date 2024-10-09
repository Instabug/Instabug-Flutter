package com.instabug.flutter;

import static com.instabug.flutter.util.GlobalMocks.reflected;
import static com.instabug.flutter.util.MockResult.makeResult;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.doReturn;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.mockConstruction;
import static org.mockito.Mockito.mockStatic;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import android.app.Application;
import android.graphics.Bitmap;
import android.net.Uri;

import com.instabug.bug.BugReporting;
import com.instabug.flutter.generated.InstabugPigeon;
import com.instabug.flutter.modules.InstabugApi;
import com.instabug.flutter.util.GlobalMocks;
import com.instabug.flutter.util.MockReflected;
import com.instabug.flutter.util.privateViews.PrivateViewManager;
import com.instabug.library.Feature;
import com.instabug.library.Instabug;
import com.instabug.library.InstabugColorTheme;
import com.instabug.library.InstabugCustomTextPlaceHolder;
import com.instabug.library.IssueType;
import com.instabug.library.LogLevel;
import com.instabug.library.Platform;
import com.instabug.library.ReproConfigurations;
import com.instabug.library.ReproMode;
import com.instabug.library.featuresflags.model.IBGFeatureFlag;
import com.instabug.library.invocation.InstabugInvocationEvent;
import com.instabug.library.model.NetworkLog;
import com.instabug.library.ui.onboarding.WelcomeMessage;

import org.json.JSONObject;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.mockito.MockedConstruction;
import org.mockito.MockedStatic;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.concurrent.Callable;

import io.flutter.plugin.common.BinaryMessenger;

public class InstabugApiTest {
    private final Callable<Bitmap> screenshotProvider = () -> mock(Bitmap.class);

    private final Application mContext = mock(Application.class);
    private InstabugApi api;
    private MockedStatic<Instabug> mInstabug;
    private MockedStatic<BugReporting> mBugReporting;
    private MockedConstruction<InstabugCustomTextPlaceHolder> mCustomTextPlaceHolder;
    private MockedStatic<InstabugPigeon.InstabugHostApi> mHostApi;

    @Before
    public void setUp() throws NoSuchMethodException {
        mCustomTextPlaceHolder = mockConstruction(InstabugCustomTextPlaceHolder.class);
        api = spy(new InstabugApi(mContext, mock(PrivateViewManager.class)));
        mInstabug = mockStatic(Instabug.class);
        mBugReporting = mockStatic(BugReporting.class);
        mHostApi = mockStatic(InstabugPigeon.InstabugHostApi.class);
        GlobalMocks.setUp();
    }

    @After
    public void cleanUp() {
        mCustomTextPlaceHolder.close();
        mInstabug.close();
        mBugReporting.close();
        mHostApi.close();
        GlobalMocks.close();
    }

    @Test
    public void testInit() {
        BinaryMessenger messenger = mock(BinaryMessenger.class);

        InstabugApi.init(messenger, mContext, mock(PrivateViewManager.class));

        mHostApi.verify(() -> InstabugPigeon.InstabugHostApi.setup(eq(messenger), any(InstabugApi.class)));
    }

    @Test
    public void testSetCurrentPlatform() {
        api.setCurrentPlatform();

        reflected.verify(() -> MockReflected.setCurrentPlatform(Platform.FLUTTER));
    }

    @Test
    public void testSdkInit() {
        String token = "app-token";
        List<String> invocationEvents = Collections.singletonList("InvocationEvent.floatingButton");
        String logLevel = "LogLevel.error";

        MockedConstruction<Instabug.Builder> mInstabugBuilder = mockConstruction(Instabug.Builder.class, (mock, context) -> {
            String actualToken = (String) context.arguments().get(1);
            // Initializes Instabug with the correct token
            assertEquals(token, actualToken);
            when(mock.setInvocationEvents(any())).thenReturn(mock);
            when(mock.setSdkDebugLogsLevel(anyInt())).thenReturn(mock);
        });

        api.init(token, invocationEvents, logLevel);

        Instabug.Builder builder = mInstabugBuilder.constructed().get(0);

        // Initializes Instabug with correct the invocation events
        assertEquals(
                "expected Instabug to be initialized using Instabug.Builder",
                1,
                mInstabugBuilder.constructed().size()
        );
        verify(builder).setInvocationEvents(InstabugInvocationEvent.FLOATING_BUTTON);
        verify(builder).setSdkDebugLogsLevel(LogLevel.ERROR);
        verify(builder).build();

        // Sets screenshot provider
        mInstabug.verify(() -> Instabug.setScreenshotProvider(screenshotProvider));

        // Sets current platform
        reflected.verify(() -> MockReflected.setCurrentPlatform(Platform.FLUTTER));
    }

    @Test
    public void testSetEnabledGivenTrue() {
        boolean isEnabled = true;

        api.setEnabled(isEnabled);

        mInstabug.verify(Instabug::enable);
    }

    @Test
    public void testSetEnabledGivenFalse() {
        boolean isEnabled = false;

        api.setEnabled(isEnabled);

        mInstabug.verify(Instabug::disable);
    }

    @Test
    public void testIsEnabled() {
        api.isEnabled();

        mInstabug.verify(Instabug::isEnabled);
    }

    @Test
    public void testIsBuilt() {
        api.isBuilt();

        mInstabug.verify(Instabug::isBuilt);
    }

    @Test
    public void testShow() {
        api.show();
        mInstabug.verify(Instabug::show);
    }

    @Test
    public void testShowWelcomeMessageWithMode() {
        String mode = "WelcomeMessageMode.live";

        api.showWelcomeMessageWithMode(mode);

        mInstabug.verify(() -> Instabug.showWelcomeMessage(WelcomeMessage.State.LIVE));
    }

    @Test
    public void testIdentifyUser() {
        String email = "inst@bug.com";
        String name = "John Doe";
        String id = "123";

        api.identifyUser(email, name, id);

        mInstabug.verify(() -> Instabug.identifyUser(name, email, id));
    }

    @Test
    public void testSetUserData() {
        String data = "premium";

        api.setUserData(data);

        mInstabug.verify(() -> Instabug.setUserData(data));
    }

    @Test
    public void testLogUserEvent() {
        String event = "sign_up";

        api.logUserEvent(event);

        mInstabug.verify(() -> Instabug.logUserEvent(event));
    }

    @Test
    public void testLogOut() {
        api.logOut();

        mInstabug.verify(Instabug::logoutUser);
    }

    @Test
    public void testSetLocale() {
        String locale = "IBGLocale.japanese";

        api.setLocale(locale);

        mInstabug.verify(() -> Instabug.setLocale(any(Locale.class)));
    }

    @Test
    public void testSetColorTheme() {
        String theme = "ColorTheme.dark";

        api.setColorTheme(theme);

        mInstabug.verify(() -> Instabug.setColorTheme(InstabugColorTheme.InstabugColorThemeDark));
    }

    @Test
    public void testSetWelcomeMessageMode() {
        String mode = "WelcomeMessageMode.beta";

        api.setWelcomeMessageMode(mode);

        mInstabug.verify(() -> Instabug.setWelcomeMessageState(WelcomeMessage.State.BETA));
    }

    @Test
    public void testSetPrimaryColor() {
        Long color = 0xFF0000L;

        api.setPrimaryColor(color);

        mInstabug.verify(() -> Instabug.setPrimaryColor(0xFF0000));
    }

    @Test
    public void testSetSessionProfilerEnabledGivenTrue() {
        Boolean isEnabled = true;

        api.setSessionProfilerEnabled(isEnabled);

        mInstabug.verify(() -> Instabug.setSessionProfilerState(Feature.State.ENABLED));
    }

    @Test
    public void testSetSessionProfilerEnabledGivenFalse() {
        Boolean isEnabled = false;

        api.setSessionProfilerEnabled(isEnabled);

        mInstabug.verify(() -> Instabug.setSessionProfilerState(Feature.State.DISABLED));
    }

    @Test
    public void testSetValueForStringWithKeyWhenKeyExists() {
        String value = "Send a bug report";
        String key = "CustomTextPlaceHolderKey.reportBug";

        api.setValueForStringWithKey(value, key);

        mInstabug.verify(() -> Instabug.setCustomTextPlaceHolders(any(InstabugCustomTextPlaceHolder.class)));
    }

    @Test
    public void testSetValueForStringWithKeyWhenKeyDoesNotExists() {
        String value = "Wingardium Leviosa";
        String key = "CustomTextPlaceHolderKey.wingardiumLeviosa";

        api.setValueForStringWithKey(value, key);

        mInstabug.verify(() -> Instabug.setCustomTextPlaceHolders(any(InstabugCustomTextPlaceHolder.class)), never());
    }

    @Test
    public void testAppendTags() {
        List<String> tags = Arrays.asList("premium", "star");

        api.appendTags(tags);

        mInstabug.verify(() -> Instabug.addTags("premium", "star"));
    }

    @Test
    public void testResetTags() {
        api.resetTags();

        mInstabug.verify(Instabug::resetTags);
    }

    @Test
    public void testGetTags() {
        InstabugPigeon.Result<List<String>> result = makeResult((tags) -> assertEquals(Collections.emptyList(), tags));

        api.getTags(result);

        mInstabug.verify(Instabug::getTags);
    }

    @Test
    public void testAddExperiments() {
        List<String> experiments = Arrays.asList("premium", "star");

        api.addExperiments(experiments);

        mInstabug.verify(() -> Instabug.addExperiments(experiments));
    }

    @Test
    public void testRemoveExperiments() {
        List<String> experiments = Arrays.asList("premium", "star");

        api.removeExperiments(experiments);

        mInstabug.verify(() -> Instabug.removeExperiments(experiments));
    }

    @Test
    public void testClearAllExperiments() {
        api.clearAllExperiments();

        mInstabug.verify(Instabug::clearAllExperiments);
    }

    @Test
    public void testAddFeatureFlags() {
       Map<String,String > featureFlags = new HashMap<>();
        featureFlags.put("key1","variant1");
        api.addFeatureFlags(featureFlags);
        List<IBGFeatureFlag> flags=new ArrayList<IBGFeatureFlag>();
        flags.add(new IBGFeatureFlag("key1","variant1"));
        mInstabug.verify(() -> Instabug.addFeatureFlags(flags));
    }

    @Test
    public void testRemoveFeatureFlags() {
        List<String> featureFlags = Arrays.asList("premium", "star");

        api.removeFeatureFlags(featureFlags);

        mInstabug.verify(() -> Instabug.removeFeatureFlag(featureFlags));
    }

    @Test
    public void testClearAllFeatureFlags() {
        api.removeAllFeatureFlags();

        mInstabug.verify(Instabug::removeAllFeatureFlags);
    }

    @Test
    public void testSetUserAttribute() {
        String key = "is_premium";
        String value = "true";
        api.setUserAttribute(value, key);

        mInstabug.verify(() -> Instabug.setUserAttribute(key, value));
    }

    @Test
    public void testRemoveUserAttribute() {
        String key = "is_premium";

        api.removeUserAttribute(key);

        mInstabug.verify(() -> Instabug.removeUserAttribute(key));
    }

    @Test
    public void testGetUserAttributeForKey() {
        String key = "is_premium";
        String expected = "yup";

        InstabugPigeon.Result<String> result = makeResult((actual) -> assertEquals(expected, actual));

        mInstabug.when(() -> Instabug.getUserAttribute(key)).thenReturn(expected);

        api.getUserAttributeForKey(key, result);

        mInstabug.verify(() -> Instabug.getUserAttribute(key));
    }

    @Test
    public void testGetUserAttributes() {
        Map<String, String> expected = new HashMap<>();
        expected.put("plan", "hobby");

        InstabugPigeon.Result<Map<String, String>> result = makeResult((actual) -> assertEquals(expected, actual));

        mInstabug.when(Instabug::getAllUserAttributes).thenReturn(expected);

        api.getUserAttributes(result);

        mInstabug.verify(Instabug::getAllUserAttributes);
    }

    @Test
    public void testSetReproStepsConfig() {
        String bug = "ReproStepsMode.enabled";
        String crash = "ReproStepsMode.disabled";
        String sessionReplay = "ReproStepsMode.disabled";

        ReproConfigurations config = mock(ReproConfigurations.class);
        MockedConstruction<ReproConfigurations.Builder> mReproConfigurationsBuilder = mockConstruction(ReproConfigurations.Builder.class, (mock, context) -> {
            when(mock.setIssueMode(anyInt(), anyInt())).thenReturn(mock);
            when(mock.build()).thenReturn(config);
        });

        api.setReproStepsConfig(bug, crash, sessionReplay);

        ReproConfigurations.Builder builder = mReproConfigurationsBuilder.constructed().get(0);

        verify(builder).setIssueMode(IssueType.Bug, ReproMode.EnableWithScreenshots);
        verify(builder).setIssueMode(IssueType.Crash, ReproMode.Disable);
        verify(builder).setIssueMode(IssueType.SessionReplay, ReproMode.Disable);
        verify(builder).build();

        mInstabug.verify(() -> Instabug.setReproConfigurations(config));
    }

    @Test
    public void testReportScreenChange() {
        String screenName = "HomeScreen";

        api.reportScreenChange(screenName);

        reflected.verify(() -> MockReflected.reportScreenChange(null, screenName));
    }

    @Test
    public void testSetCustomBrandingImageGivenLightAndDark() {
        String light = "images/light_logo.png";
        String dark = "images/dark_logo.png";
        Bitmap lightLogoVariant = mock(Bitmap.class);
        Bitmap darkLogoVariant = mock(Bitmap.class);

        doReturn(lightLogoVariant).when(api).getBitmapForAsset(light);
        doReturn(darkLogoVariant).when(api).getBitmapForAsset(dark);

        api.setCustomBrandingImage(light, dark);

        reflected.verify(() -> MockReflected.setCustomBrandingImage(lightLogoVariant, darkLogoVariant));
    }

    @Test
    public void testSetCustomBrandingImageGivenLightOnly() {
        String light = "images/light_logo.png";
        String dark = "images/dark_logo.png";
        Bitmap lightLogoVariant = mock(Bitmap.class);

        doReturn(lightLogoVariant).when(api).getBitmapForAsset(light);
        doReturn(null).when(api).getBitmapForAsset(dark);

        api.setCustomBrandingImage(light, dark);

        reflected.verify(() -> MockReflected.setCustomBrandingImage(lightLogoVariant, lightLogoVariant));
    }

    @Test
    public void testSetCustomBrandingImageGivenDarkOnly() {
        String light = "images/light_logo.png";
        String dark = "images/dark_logo.png";
        Bitmap darkLogoVariant = mock(Bitmap.class);

        doReturn(null).when(api).getBitmapForAsset(light);
        doReturn(darkLogoVariant).when(api).getBitmapForAsset(dark);

        api.setCustomBrandingImage(light, dark);

        reflected.verify(() -> MockReflected.setCustomBrandingImage(darkLogoVariant, darkLogoVariant));
    }

    @Test
    public void testSetCustomBrandingImageGivenNoLogo() {
        String light = "images/light_logo.png";
        String dark = "images/dark_logo.png";

        doReturn(null).when(api).getBitmapForAsset(any());

        api.setCustomBrandingImage(light, dark);

        reflected.verify(() -> MockReflected.setCustomBrandingImage(any(), any()), never());
    }

    @Test
    public void testAddFileAttachmentWithURLWhenFileExists() throws IOException {
        String path = "buggy.txt";
        String name = "Buggy";

        // Create file for file.exists() to be true
        File file = new File(path);
        boolean fileCreated = file.exists() || file.createNewFile();
        assertTrue("Failed to create a file", fileCreated);

        api.addFileAttachmentWithURL(path, name);

        mInstabug.verify(() -> Instabug.addFileAttachment(any(Uri.class), eq(name)));

        file.delete();
    }

    @Test
    public void testAddFileAttachmentWithURLWhenFileDoesNotExists() {
        String path = "somewhere/that_does_not_exist.png";
        String name = "Buggy";

        api.addFileAttachmentWithURL(path, name);

        mInstabug.verify(() -> Instabug.addFileAttachment(any(Uri.class), eq(name)), never());
    }

    @Test
    public void testAddFileAttachmentWithData() {
        byte[] data = new byte[]{65, 100};
        String name = "Issue";

        api.addFileAttachmentWithData(data, name);

        mInstabug.verify(() -> Instabug.addFileAttachment(data, name));
    }

    @Test
    public void testClearFileAttachments() {
        api.clearFileAttachments();

        mInstabug.verify(Instabug::clearFileAttachment);
    }

    @Test
    public void testNetworkLog() {
        String url = "https://example.com";
        String requestBody = "hi";
        String responseBody = "{\"hello\":\"world\"}";
        String method = "POST";
        int responseCode = 201;
        long duration = 23000;
        HashMap<String, String> requestHeaders = new HashMap<>();
        HashMap<String, String> responseHeaders = new HashMap<>();
        Map<String, Object> data = new HashMap<>();
        data.put("url", url);
        data.put("requestBody", requestBody);
        data.put("responseBody", responseBody);
        data.put("method", method);
        data.put("responseCode", responseCode);
        data.put("requestHeaders", requestHeaders);
        data.put("responseHeaders", responseHeaders);
        data.put("duration", duration);

        MockedConstruction<NetworkLog> mNetworkLog = mockConstruction(NetworkLog.class);

        MockedConstruction<JSONObject> mJSONObject = mockConstruction(JSONObject.class, (mock, context) -> when(mock.toString(anyInt())).thenReturn("{}"));

        api.networkLog(data);

        NetworkLog networkLog = mNetworkLog.constructed().get(0);

        verify(networkLog).setDate(anyString());
        verify(networkLog).setUrl(url);
        verify(networkLog).setRequest(requestBody);
        verify(networkLog).setResponse(responseBody);
        verify(networkLog).setMethod(method);
        verify(networkLog).setResponseCode(responseCode);
        verify(networkLog).setRequestHeaders("{}");
        verify(networkLog).setResponseHeaders("{}");
        verify(networkLog).setTotalDuration(duration / 1000);
        verify(networkLog).insert();

        mJSONObject.close();
    }

    @Test
    public void testWillRedirectToStore() {
        api.willRedirectToStore();
        mInstabug.verify(Instabug::willRedirectToStore);
    }
}
