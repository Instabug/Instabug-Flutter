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
    private final RepliesApi mApi = new RepliesApi(null);
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
        BinaryMessenger messenger = mock(BinaryMessenger.class);

        RepliesApi.init(messenger);

        mHostApi.verify(() -> RepliesPigeon.RepliesHostApi.setup(eq(messenger), any(RepliesApi.class)));
    }

    @Test
    public void testSetEnabledGivenTrue() {
        boolean isEnabled = true;

        mApi.setEnabled(isEnabled);

        mReplies.verify(() -> Replies.setState(Feature.State.ENABLED));
    }

    @Test
    public void testSetEnabledGivenFalse() {
        boolean isEnabled = false;

        mApi.setEnabled(isEnabled);

        mReplies.verify(() -> Replies.setState(Feature.State.DISABLED));
    }

    @Test
    public void testShow() {
        mApi.show();

        mReplies.verify(Replies::show);
    }

    @Test
    public void testSetInAppNotificationsEnabled() {
        boolean isEnabled = true;

        mApi.setInAppNotificationsEnabled(isEnabled);

        mReplies.verify(() -> Replies.setInAppNotificationEnabled(isEnabled));
    }

    @Test
    public void testSetInAppNotificationSound() {
        boolean isEnabled = true;

        mApi.setInAppNotificationSound(isEnabled);

        mReplies.verify(() -> Replies.setInAppNotificationSound(isEnabled));
    }

    @Test
    public void testGetUnreadRepliesCount() {
        long expected = 5;
        RepliesPigeon.Result<Long> result = spy(makeResult((actual) -> assertEquals(expected, (long) actual)));

        mReplies.when(Replies::getUnreadRepliesCount).thenReturn((int) expected);

        mApi.getUnreadRepliesCount(result);

        verify(result).success(expected);
        mReplies.verify(Replies::getUnreadRepliesCount);
    }

    @Test
    public void testHasChats() {
        boolean expected = true;
        RepliesPigeon.Result<Boolean> result = spy(makeResult((actual) -> assertEquals(expected, actual)));

        mReplies.when(Replies::hasChats).thenReturn(expected);

        mApi.hasChats(result);

        verify(result).success(expected);
        mReplies.verify(Replies::hasChats);
    }

    @Test
    public void testBindOnNewReplyCallback() {
        mApi.bindOnNewReplyCallback();

        mReplies.verify(() -> Replies.setOnNewReplyReceivedCallback(any(Runnable.class)));
    }
}
