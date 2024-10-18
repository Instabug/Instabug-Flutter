package com.instabug.flutter;

import static com.instabug.flutter.util.MockResult.makeResult;
import static org.junit.Assert.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.mockStatic;
import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.verify;

import com.instabug.chat.Replies;
import com.instabug.flutter.generated.RepliesPigeon;
import com.instabug.flutter.modules.RepliesApi;
import com.instabug.flutter.util.GlobalMocks;
import com.instabug.library.Feature;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.mockito.MockedStatic;

import io.flutter.plugin.common.BinaryMessenger;


public class RepliesApiTest {
    private final BinaryMessenger mMessenger = mock(BinaryMessenger.class);
    private final RepliesPigeon.RepliesFlutterApi flutterApi = new RepliesPigeon.RepliesFlutterApi(mMessenger);
    private final RepliesApi api = new RepliesApi(flutterApi);
    private MockedStatic<Replies> mReplies;
    private MockedStatic<RepliesPigeon.RepliesHostApi> mHostApi;

    @Before
    public void setUp() throws NoSuchMethodException {
        mReplies = mockStatic(Replies.class);
        mHostApi = mockStatic(RepliesPigeon.RepliesHostApi.class);
        GlobalMocks.setUp();
    }

    @After
    public void cleanUp() {
        mReplies.close();
        mHostApi.close();
        GlobalMocks.close();
    }

    @Test
    public void testInit() {
        RepliesApi.init(mMessenger);

        mHostApi.verify(() -> RepliesPigeon.RepliesHostApi.setup(eq(mMessenger), any(RepliesApi.class)));
    }

    @Test
    public void testSetEnabledGivenTrue() {
        boolean isEnabled = true;

        api.setEnabled(isEnabled);

        mReplies.verify(() -> Replies.setState(Feature.State.ENABLED));
    }

    @Test
    public void testSetEnabledGivenFalse() {
        boolean isEnabled = false;

        api.setEnabled(isEnabled);

        mReplies.verify(() -> Replies.setState(Feature.State.DISABLED));
    }

    @Test
    public void testShow() {
        api.show();

        mReplies.verify(Replies::show);
    }

    @Test
    public void testSetInAppNotificationsEnabled() {
        boolean isEnabled = true;

        api.setInAppNotificationsEnabled(isEnabled);

        mReplies.verify(() -> Replies.setInAppNotificationEnabled(isEnabled));
    }

    @Test
    public void testSetInAppNotificationSound() {
        boolean isEnabled = true;

        api.setInAppNotificationSound(isEnabled);

        mReplies.verify(() -> Replies.setInAppNotificationSound(isEnabled));
    }

    @Test
    public void testGetUnreadRepliesCount() {
        long expected = 5;
        RepliesPigeon.Result<Long> result = spy(makeResult((actual) -> assertEquals(expected, (long) actual)));

        mReplies.when(Replies::getUnreadRepliesCount).thenReturn((int) expected);

        api.getUnreadRepliesCount(result);

        verify(result).success(expected);
        mReplies.verify(Replies::getUnreadRepliesCount);
    }

    @Test
    public void testHasChats() {
        boolean expected = true;
        RepliesPigeon.Result<Boolean> result = spy(makeResult((actual) -> assertEquals(expected, actual)));

        mReplies.when(Replies::hasChats).thenReturn(expected);

        api.hasChats(result);

        verify(result).success(expected);
        mReplies.verify(Replies::hasChats);
    }

    @Test
    public void testBindOnNewReplyCallback() {
        api.bindOnNewReplyCallback();

        mReplies.verify(() -> Replies.setOnNewReplyReceivedCallback(any(Runnable.class)));
    }
}
