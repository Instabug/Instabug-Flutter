package com.instabug.flutter;

import static com.instabug.flutter.util.GlobalMocks.reflected;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.mockStatic;

import com.instabug.featuresrequest.ActionType;
import com.instabug.featuresrequest.FeatureRequests;
import com.instabug.flutter.generated.FeatureRequestsPigeon;
import com.instabug.flutter.modules.FeatureRequestsApi;
import com.instabug.flutter.util.GlobalMocks;
import com.instabug.flutter.util.MockReflected;
import com.instabug.library.Feature;

import org.json.JSONObject;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.mockito.MockedStatic;

import java.util.ArrayList;
import java.util.List;

import io.flutter.plugin.common.BinaryMessenger;


public class FeatureRequestsApiTest {
    private final FeatureRequestsApi mApi = new FeatureRequestsApi();
    private MockedStatic<FeatureRequests> mFeatureRequests;
    private MockedStatic<FeatureRequestsPigeon.FeatureRequestsHostApi> mHostApi;

    @Before
    public void setUp() throws NoSuchMethodException {
        mFeatureRequests = mockStatic(FeatureRequests.class);
        mHostApi = mockStatic(FeatureRequestsPigeon.FeatureRequestsHostApi.class);
        GlobalMocks.setUp();
    }

    @After
    public void cleanUp() {
        mFeatureRequests.close();
        mHostApi.close();
        GlobalMocks.close();
    }

    @Test
    public void testInit() {
        BinaryMessenger messenger = mock(BinaryMessenger.class);

        FeatureRequestsApi.init(messenger);

        mHostApi.verify(() -> FeatureRequestsPigeon.FeatureRequestsHostApi.setup(eq(messenger), any(FeatureRequestsApi.class)));
    }

    @Test
    public void testShow() {
        mApi.show();

        mFeatureRequests.verify(FeatureRequests::show);
    }

    @Test
    public void testSetEmailFieldRequired() {
        boolean isRequired = true;
        List<String> actionTypes = new ArrayList<>();
        actionTypes.add("ActionType.requestNewFeature");
        actionTypes.add("ActionType.addCommentToFeature");

        mApi.setEmailFieldRequired(isRequired, actionTypes);

        mFeatureRequests.verify(() -> FeatureRequests.setEmailFieldRequired(isRequired, ActionType.REQUEST_NEW_FEATURE, ActionType.ADD_COMMENT_TO_FEATURE));
    }
}
