package com.instabug.flutter;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.mockStatic;

import com.instabug.bug.BugReporting;
import com.instabug.bug.invocation.Option;
import com.instabug.flutter.generated.BugReportingPigeon;
import com.instabug.flutter.modules.BugReportingApi;
import com.instabug.flutter.util.GlobalMocks;
import com.instabug.library.Feature;
import com.instabug.library.OnSdkDismissCallback;
import com.instabug.library.extendedbugreport.ExtendedBugReport;
import com.instabug.library.invocation.InstabugInvocationEvent;
import com.instabug.library.invocation.OnInvokeCallback;
import com.instabug.library.invocation.util.InstabugFloatingButtonEdge;
import com.instabug.library.invocation.util.InstabugVideoRecordingButtonPosition;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.mockito.MockedStatic;

import java.util.ArrayList;
import java.util.List;

import io.flutter.plugin.common.BinaryMessenger;


public class BugReportingApiTest {
    private final BugReportingApi mApi = new BugReportingApi(null);
    private MockedStatic<BugReporting> mBugReporting;
    private MockedStatic<BugReportingPigeon.BugReportingHostApi> mHostApi;

    @Before
    public void setUp() throws NoSuchMethodException {
        mBugReporting = mockStatic(BugReporting.class);
        mHostApi = mockStatic(BugReportingPigeon.BugReportingHostApi.class);
        GlobalMocks.setUp();
    }

    @After
    public void cleanUp() {
        mBugReporting.close();
        mHostApi.close();
        GlobalMocks.close();
    }

    @Test
    public void testInit() {
        BinaryMessenger messenger = mock(BinaryMessenger.class);

        BugReportingApi.init(messenger);

        mHostApi.verify(() -> BugReportingPigeon.BugReportingHostApi.setup(eq(messenger), any(BugReportingApi.class)));
    }

    @Test
    public void testSetEnabledGivenTrue() {
        boolean isEnabled = true;

        mApi.setEnabled(isEnabled);

        mBugReporting.verify(() -> BugReporting.setState(Feature.State.ENABLED));
    }

    @Test
    public void testSetEnabledGivenFalse() {
        boolean isEnabled = false;

        mApi.setEnabled(isEnabled);

        mBugReporting.verify(() -> BugReporting.setState(Feature.State.DISABLED));
    }

    @Test
    public void testShow() {
        String reportType = "ReportType.bug";
        List<String> invocationOptions = new ArrayList<>();
        invocationOptions.add("InvocationOption.emailFieldOptional");
        invocationOptions.add("InvocationOption.disablePostSendingDialog");

        mApi.show(reportType, invocationOptions);

        mBugReporting.verify(() -> BugReporting.show(BugReporting.ReportType.BUG, Option.EMAIL_FIELD_OPTIONAL, Option.DISABLE_POST_SENDING_DIALOG));
    }

    @Test
    public void testSetInvocationEvents() {
        List<String> events = new ArrayList<>();
        events.add("InvocationEvent.floatingButton");
        events.add("InvocationEvent.screenshot");

        mApi.setInvocationEvents(events);

        mBugReporting.verify(() -> BugReporting.setInvocationEvents(InstabugInvocationEvent.FLOATING_BUTTON, InstabugInvocationEvent.SCREENSHOT));
    }

    @Test
    public void testSetReportTypes() {
        List<String> types = new ArrayList<>();
        types.add("ReportType.bug");
        types.add("ReportType.feedback");

        mApi.setReportTypes(types);

        mBugReporting.verify(() -> BugReporting.setReportTypes(BugReporting.ReportType.BUG, BugReporting.ReportType.FEEDBACK));
    }

    @Test
    public void testSetExtendedBugReportingMode() {
        String mode = "ExtendedBugReportMode.enabledWithOptionalFields";

        mApi.setExtendedBugReportMode(mode);

        mBugReporting.verify(() -> BugReporting.setExtendedBugReportState(ExtendedBugReport.State.ENABLED_WITH_OPTIONAL_FIELDS));
    }

    @Test
    public void testSetInvocationOptions() {
        List<String> options = new ArrayList<>();
        options.add("InvocationOption.emailFieldHidden");
        options.add("InvocationOption.commentFieldRequired");

        mApi.setInvocationOptions(options);

        mBugReporting.verify(() -> BugReporting.setOptions(Option.EMAIL_FIELD_HIDDEN, Option.COMMENT_FIELD_REQUIRED));
    }

    @Test
    public void testSetFloatingButtonEdge() {
        String edge = "FloatingButtonEdge.left";
        Long offset = 100L;

        mApi.setFloatingButtonEdge(edge, offset);

        mBugReporting.verify(() -> BugReporting.setFloatingButtonEdge(InstabugFloatingButtonEdge.LEFT));
        mBugReporting.verify(() -> BugReporting.setFloatingButtonOffset(offset.intValue()));
    }

    @Test
    public void testSetVideoRecordingFloatingButtonPosition() {
        String position = "Position.topRight";

        mApi.setVideoRecordingFloatingButtonPosition(position);

        mBugReporting.verify(() -> BugReporting.setVideoRecordingFloatingButtonPosition(InstabugVideoRecordingButtonPosition.TOP_RIGHT));
    }

    @Test
    public void testSetShakingThresholdForAndroid() {
        Long threshold = 300L;
        
        mApi.setShakingThresholdForAndroid(threshold);

        mBugReporting.verify(() -> BugReporting.setShakingThreshold(threshold.intValue()));
    }

    @Test
    public void testSetEnabledAttachmentTypes() {
        boolean screenshot = true;
        boolean extraScreenshot = true;
        boolean galleryImage = false;
        boolean screenRecording = true;

        mApi.setEnabledAttachmentTypes(screenshot, extraScreenshot, galleryImage, screenRecording);

        mBugReporting.verify(() -> BugReporting.setAttachmentTypesEnabled(screenshot, extraScreenshot, galleryImage, screenRecording));
    }

    @Test
    public void testBindOnInvokeCallback() {
        mApi.bindOnInvokeCallback();

        mBugReporting.verify(() -> BugReporting.setOnInvokeCallback(any(OnInvokeCallback.class)));
    }

    @Test
    public void testBindOnDismissCallback() {
        mApi.bindOnDismissCallback();

        mBugReporting.verify(() -> BugReporting.setOnDismissCallback(any(OnSdkDismissCallback.class)));
    }

    @Test
    public void testSetDisclaimerText() {
        String text = "My very own disclaimer text";

        mApi.setDisclaimerText(text);

        mBugReporting.verify(() -> BugReporting.setDisclaimerText(text));
    }

    @Test
    public void testSetCommentMinimumCharacterCount() {
        Long limit = 100L;
        List<String> reportTypes = new ArrayList<>();
        reportTypes.add("ReportType.bug");
        reportTypes.add("ReportType.question");

        mApi.setCommentMinimumCharacterCount(limit, reportTypes);

        mBugReporting.verify(() -> BugReporting.setCommentMinimumCharacterCount(limit.intValue(), BugReporting.ReportType.BUG, BugReporting.ReportType.QUESTION));
    }
}
