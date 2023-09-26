package com.instabug.flutter;

import static org.junit.Assert.assertTrue;

import com.instabug.library.LogLevel;
import com.instabug.bug.BugReporting;
import com.instabug.bug.invocation.Option;
import com.instabug.featuresrequest.ActionType;
import com.instabug.flutter.util.ArgsRegistry;
import com.instabug.library.InstabugColorTheme;
import com.instabug.library.InstabugCustomTextPlaceHolder.Key;
import com.instabug.library.OnSdkDismissCallback.DismissType;
import com.instabug.library.ReproMode;
import com.instabug.library.extendedbugreport.ExtendedBugReport;
import com.instabug.library.internal.module.InstabugLocale;
import com.instabug.library.invocation.InstabugInvocationEvent;
import com.instabug.library.invocation.util.InstabugFloatingButtonEdge;
import com.instabug.library.invocation.util.InstabugVideoRecordingButtonPosition;
import com.instabug.library.ui.onboarding.WelcomeMessage;

import org.junit.Test;

public class ArgsRegistryTest {
    @Test
    public void testSdkLogLevels() {
        Integer[] values = {
                LogLevel.NONE,
                LogLevel.ERROR,
                LogLevel.DEBUG,
                LogLevel.VERBOSE,
        };

        for (Integer value : values) {
            assertTrue(ArgsRegistry.sdkLogLevels.containsValue(value));
        }
    }

    @Test
    public void testInvocationEvents() {
        InstabugInvocationEvent[] values = {
                InstabugInvocationEvent.NONE,
                InstabugInvocationEvent.SHAKE,
                InstabugInvocationEvent.FLOATING_BUTTON,
                InstabugInvocationEvent.SCREENSHOT,
                InstabugInvocationEvent.TWO_FINGER_SWIPE_LEFT,
        };

        for (InstabugInvocationEvent value : values) {
            assertTrue(ArgsRegistry.invocationEvents.containsValue(value));
        }
    }

    @Test
    public void testInvocationOptions() {
        Integer[] values = {
                Option.EMAIL_FIELD_HIDDEN,
                Option.EMAIL_FIELD_OPTIONAL,
                Option.COMMENT_FIELD_REQUIRED,
                Option.DISABLE_POST_SENDING_DIALOG,
        };

        for (Integer value : values) {
            assertTrue(ArgsRegistry.invocationOptions.containsValue(value));
        }
    }

    @Test
    public void testColorThemes() {
        InstabugColorTheme[] values = {
                InstabugColorTheme.InstabugColorThemeLight,
                InstabugColorTheme.InstabugColorThemeDark,
        };

        for (InstabugColorTheme value : values) {
            assertTrue(ArgsRegistry.colorThemes.containsValue(value));
        }
    }

    @Test
    public void testFloatingButtonEdges() {
        InstabugFloatingButtonEdge[] values = {
                InstabugFloatingButtonEdge.LEFT,
                InstabugFloatingButtonEdge.RIGHT,
        };

        for (InstabugFloatingButtonEdge value : values) {
            assertTrue(ArgsRegistry.floatingButtonEdges.containsValue(value));
        }
    }

    @Test
    public void testRecordButtonPositions() {
        InstabugVideoRecordingButtonPosition[] values = {
                InstabugVideoRecordingButtonPosition.TOP_LEFT,
                InstabugVideoRecordingButtonPosition.TOP_RIGHT,
                InstabugVideoRecordingButtonPosition.BOTTOM_LEFT,
                InstabugVideoRecordingButtonPosition.BOTTOM_RIGHT,
        };

        for (InstabugVideoRecordingButtonPosition value : values) {
            assertTrue(ArgsRegistry.recordButtonPositions.containsValue(value));
        }
    }

    @Test
    public void testwelcomeMessageStates() {
        WelcomeMessage.State[] values = {
                WelcomeMessage.State.LIVE,
                WelcomeMessage.State.BETA,
                WelcomeMessage.State.DISABLED,
        };

        for (WelcomeMessage.State value : values) {
            assertTrue(ArgsRegistry.welcomeMessageStates.containsValue(value));
        }
    }

    @Test
    public void testReportTypes() {
        Integer[] values = {
                BugReporting.ReportType.BUG,
                BugReporting.ReportType.FEEDBACK,
                BugReporting.ReportType.QUESTION,
        };

        for (Integer value : values) {
            assertTrue(ArgsRegistry.reportTypes.containsValue(value));
        }
    }

    @Test
    public void testDismissTypes() {
        DismissType[] values = {
                DismissType.SUBMIT,
                DismissType.CANCEL,
                DismissType.ADD_ATTACHMENT,
        };

        for (DismissType value : values) {
            assertTrue(ArgsRegistry.dismissTypes.containsValue(value));
        }
    }

    @Test
    public void testActionTypes() {
        Integer[] values = {
                ActionType.REQUEST_NEW_FEATURE,
                ActionType.ADD_COMMENT_TO_FEATURE,
        };

        for (Integer value : values) {
            assertTrue(ArgsRegistry.actionTypes.containsValue(value));
        }
    }

    @Test
    public void testExtendedBugReportStates() {
        ExtendedBugReport.State[] values = {
                ExtendedBugReport.State.ENABLED_WITH_REQUIRED_FIELDS,
                ExtendedBugReport.State.ENABLED_WITH_OPTIONAL_FIELDS,
                ExtendedBugReport.State.DISABLED,
        };

        for (ExtendedBugReport.State value : values) {
            assertTrue(ArgsRegistry.extendedBugReportStates.containsValue(value));
        }
    }

    @Test
    public void testReproModes() {
        Integer[] values = {
                ReproMode.Disable,
                ReproMode.EnableWithScreenshots,
                ReproMode.EnableWithNoScreenshots,
        };

        for (Integer value : values) {
            assertTrue(ArgsRegistry.reproModes.containsValue(value));
        }
    }


    @Test
    public void testLocales() {
        InstabugLocale[] values = {
                InstabugLocale.ARABIC,
                InstabugLocale.AZERBAIJANI,
                InstabugLocale.SIMPLIFIED_CHINESE,
                InstabugLocale.TRADITIONAL_CHINESE,
                InstabugLocale.CZECH,
                InstabugLocale.DANISH,
                InstabugLocale.NETHERLANDS,
                InstabugLocale.ENGLISH,
                InstabugLocale.FINNISH,
                InstabugLocale.FRENCH,
                InstabugLocale.GERMAN,
                InstabugLocale.HUNGARIAN,
                InstabugLocale.INDONESIAN,
                InstabugLocale.ITALIAN,
                InstabugLocale.JAPANESE,
                InstabugLocale.KOREAN,
                InstabugLocale.NORWEGIAN,
                InstabugLocale.POLISH,
                InstabugLocale.PORTUGUESE_BRAZIL,
                InstabugLocale.PORTUGUESE_PORTUGAL,
                InstabugLocale.ROMANIAN,
                InstabugLocale.RUSSIAN,
                InstabugLocale.SLOVAK,
                InstabugLocale.SPANISH,
                InstabugLocale.SWEDISH,
                InstabugLocale.TURKISH,
        };

        for (InstabugLocale value : values) {
            assertTrue(ArgsRegistry.locales.containsValue(value));
        }
    }


    @Test
    public void testPlaceholder() {
        Key[] values = {
                Key.SHAKE_HINT,
                Key.SWIPE_HINT,
                Key.INVALID_EMAIL_MESSAGE,
                Key.EMAIL_FIELD_HINT,
                Key.COMMENT_FIELD_HINT_FOR_BUG_REPORT,
                Key.COMMENT_FIELD_HINT_FOR_FEEDBACK,
                Key.COMMENT_FIELD_HINT_FOR_QUESTION,
                Key.INVOCATION_HEADER,
                Key.REPORT_QUESTION,
                Key.REPORT_BUG,
                Key.REPORT_FEEDBACK,
                Key.CONVERSATIONS_LIST_TITLE,
                Key.ADD_VOICE_MESSAGE,
                Key.ADD_IMAGE_FROM_GALLERY,
                Key.ADD_EXTRA_SCREENSHOT,
                Key.ADD_VIDEO,
                Key.AUDIO_RECORDING_PERMISSION_DENIED,
                Key.VOICE_MESSAGE_PRESS_AND_HOLD_TO_RECORD,
                Key.VOICE_MESSAGE_RELEASE_TO_ATTACH,
                Key.SUCCESS_DIALOG_HEADER,
                Key.VIDEO_RECORDING_FAB_BUBBLE_HINT,
                Key.CONVERSATION_TEXT_FIELD_HINT,
                Key.REPORT_SUCCESSFULLY_SENT,

                Key.BETA_WELCOME_MESSAGE_WELCOME_STEP_TITLE,
                Key.BETA_WELCOME_MESSAGE_WELCOME_STEP_CONTENT,
                Key.BETA_WELCOME_MESSAGE_HOW_TO_REPORT_STEP_TITLE,
                Key.BETA_WELCOME_MESSAGE_HOW_TO_REPORT_STEP_CONTENT,
                Key.BETA_WELCOME_MESSAGE_FINISH_STEP_TITLE,
                Key.BETA_WELCOME_MESSAGE_FINISH_STEP_CONTENT,
                Key.LIVE_WELCOME_MESSAGE_TITLE,
                Key.LIVE_WELCOME_MESSAGE_CONTENT,

                Key.SURVEYS_STORE_RATING_THANKS_TITLE,
                Key.SURVEYS_STORE_RATING_THANKS_SUBTITLE,

                Key.REPORT_BUG_DESCRIPTION,
                Key.REPORT_FEEDBACK_DESCRIPTION,
                Key.REPORT_QUESTION_DESCRIPTION,
                Key.REQUEST_FEATURE_DESCRIPTION,

                Key.REPORT_DISCARD_DIALOG_TITLE,
                Key.REPORT_DISCARD_DIALOG_BODY,
                Key.REPORT_DISCARD_DIALOG_NEGATIVE_ACTION,
                Key.REPORT_DISCARD_DIALOG_POSITIVE_ACTION,
                Key.REPORT_ADD_ATTACHMENT_HEADER,

                Key.REPORT_REPRO_STEPS_DISCLAIMER_BODY,
                Key.REPORT_REPRO_STEPS_DISCLAIMER_LINK,
                Key.REPRO_STEPS_PROGRESS_DIALOG_BODY,
                Key.REPRO_STEPS_LIST_HEADER,
                Key.REPRO_STEPS_LIST_DESCRIPTION,
                Key.REPRO_STEPS_LIST_EMPTY_STATE_DESCRIPTION,
                Key.REPRO_STEPS_LIST_ITEM_NUMBERING_TITLE,

                Key.CHATS_TEAM_STRING_NAME,
                Key.REPLIES_NOTIFICATION_REPLY_BUTTON,
                Key.REPLIES_NOTIFICATION_DISMISS_BUTTON,

                Key.BUG_ATTACHMENT_DIALOG_OK_BUTTON,
                Key.CHATS_TYPE_AUDIO,
                Key.CHATS_TYPE_IMAGE,
                Key.CHATS_TYPE_VIDEO,
                Key.CHATS_MULTIPLE_MESSAGE_NOTIFICATION,
                Key.COMMENT_FIELD_INSUFFICIENT_CONTENT,
        };

        for (Key value : values) {
            assertTrue(ArgsRegistry.placeholders.containsValue(value));
        }
    }

}
