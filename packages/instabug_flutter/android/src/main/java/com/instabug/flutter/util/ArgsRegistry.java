package com.instabug.flutter.util;

import androidx.annotation.NonNull;

import com.instabug.crash.models.IBGNonFatalException;
import com.instabug.library.LogLevel;
import com.instabug.bug.BugReporting;
import com.instabug.bug.invocation.Option;
import com.instabug.featuresrequest.ActionType;
import com.instabug.library.InstabugColorTheme;
import com.instabug.library.InstabugCustomTextPlaceHolder.Key;
import com.instabug.library.MaskingType;
import com.instabug.library.OnSdkDismissCallback.DismissType;
import com.instabug.library.ReproMode;
import com.instabug.library.extendedbugreport.ExtendedBugReport;
import com.instabug.library.internal.module.InstabugLocale;
import com.instabug.library.invocation.InstabugInvocationEvent;
import com.instabug.library.invocation.util.InstabugFloatingButtonEdge;
import com.instabug.library.invocation.util.InstabugVideoRecordingButtonPosition;
import com.instabug.library.model.StepType;
import com.instabug.library.ui.onboarding.WelcomeMessage;

import java.util.HashMap;
import java.util.Objects;

public final class ArgsRegistry {

    public static class ArgsMap<T> extends HashMap<String, T> {
        @NonNull
        @Override
        public T get(Object key) {
            return Objects.requireNonNull(super.get(key));
        }
    }

    public static final ArgsMap<Integer> sdkLogLevels = new ArgsMap<Integer>() {{
        put("LogLevel.none", LogLevel.NONE);
        put("LogLevel.error", LogLevel.ERROR);
        put("LogLevel.debug", LogLevel.DEBUG);
        put("LogLevel.verbose", LogLevel.VERBOSE);
    }};

    public static ArgsMap<InstabugInvocationEvent> invocationEvents = new ArgsMap<InstabugInvocationEvent>() {{
        put("InvocationEvent.none", InstabugInvocationEvent.NONE);
        put("InvocationEvent.shake", InstabugInvocationEvent.SHAKE);
        put("InvocationEvent.floatingButton", InstabugInvocationEvent.FLOATING_BUTTON);
        put("InvocationEvent.screenshot", InstabugInvocationEvent.SCREENSHOT);
        put("InvocationEvent.twoFingersSwipeLeft", InstabugInvocationEvent.TWO_FINGER_SWIPE_LEFT);
    }};

    public static final ArgsMap<Integer> invocationOptions = new ArgsMap<Integer>() {{
        put("InvocationOption.emailFieldHidden", Option.EMAIL_FIELD_HIDDEN);
        put("InvocationOption.emailFieldOptional", Option.EMAIL_FIELD_OPTIONAL);
        put("InvocationOption.commentFieldRequired", Option.COMMENT_FIELD_REQUIRED);
        put("InvocationOption.disablePostSendingDialog", Option.DISABLE_POST_SENDING_DIALOG);
    }};

    public static final ArgsMap<InstabugColorTheme> colorThemes = new ArgsMap<InstabugColorTheme>() {{
        put("ColorTheme.light", InstabugColorTheme.InstabugColorThemeLight);
        put("ColorTheme.dark", InstabugColorTheme.InstabugColorThemeDark);
    }};

    public static final ArgsMap<Integer> autoMasking = new ArgsMap<Integer>() {{
        put("AutoMasking.labels", MaskingType.LABELS);
        put("AutoMasking.textInputs", MaskingType.TEXT_INPUTS);
        put("AutoMasking.media", MaskingType.MEDIA);
        put("AutoMasking.none", MaskingType.MASK_NOTHING);
    }};

   public static ArgsMap<IBGNonFatalException.Level> nonFatalExceptionLevel = new ArgsMap<IBGNonFatalException.Level>() {{
        put("NonFatalExceptionLevel.critical", IBGNonFatalException.Level.CRITICAL);
        put("NonFatalExceptionLevel.error", IBGNonFatalException.Level.ERROR);
        put("NonFatalExceptionLevel.warning", IBGNonFatalException.Level.WARNING);
        put("NonFatalExceptionLevel.info", IBGNonFatalException.Level.INFO);
    }};
    public static final ArgsMap<InstabugFloatingButtonEdge> floatingButtonEdges = new ArgsMap<InstabugFloatingButtonEdge>() {{
        put("FloatingButtonEdge.left", InstabugFloatingButtonEdge.LEFT);
        put("FloatingButtonEdge.right", InstabugFloatingButtonEdge.RIGHT);
    }};

    public static ArgsMap<InstabugVideoRecordingButtonPosition> recordButtonPositions = new ArgsMap<InstabugVideoRecordingButtonPosition>() {{
        put("Position.topLeft", InstabugVideoRecordingButtonPosition.TOP_LEFT);
        put("Position.topRight", InstabugVideoRecordingButtonPosition.TOP_RIGHT);
        put("Position.bottomLeft", InstabugVideoRecordingButtonPosition.BOTTOM_LEFT);
        put("Position.bottomRight", InstabugVideoRecordingButtonPosition.BOTTOM_RIGHT);
    }};

    public static final ArgsMap<String> userConsentActionType = new ArgsMap<String>() {{
        put("UserConsentActionType.dropAutoCapturedMedia",  com.instabug.bug.userConsent.ActionType.DROP_AUTO_CAPTURED_MEDIA);
        put("UserConsentActionType.dropLogs",  com.instabug.bug.userConsent.ActionType.DROP_LOGS);
        put("UserConsentActionType.noChat",  com.instabug.bug.userConsent.ActionType.NO_CHAT);
    }};

    public static ArgsMap<WelcomeMessage.State> welcomeMessageStates = new ArgsMap<WelcomeMessage.State>() {{
        put("WelcomeMessageMode.live", WelcomeMessage.State.LIVE);
        put("WelcomeMessageMode.beta", WelcomeMessage.State.BETA);
        put("WelcomeMessageMode.disabled", WelcomeMessage.State.DISABLED);
    }};

    public static final ArgsMap<Integer> reportTypes = new ArgsMap<Integer>() {{
        put("ReportType.bug", BugReporting.ReportType.BUG);
        put("ReportType.feedback", BugReporting.ReportType.FEEDBACK);
        put("ReportType.question", BugReporting.ReportType.QUESTION);
    }};

    public static final ArgsMap<DismissType> dismissTypes = new ArgsMap<DismissType>() {{
        put("dismissTypeSubmit", DismissType.SUBMIT);
        put("dismissTypeCancel", DismissType.CANCEL);
        put("dismissTypeAddAttachment", DismissType.ADD_ATTACHMENT);
    }};

    public static final ArgsMap<Integer> actionTypes = new ArgsMap<Integer>() {{
        put("ActionType.requestNewFeature", ActionType.REQUEST_NEW_FEATURE);
        put("ActionType.addCommentToFeature", ActionType.ADD_COMMENT_TO_FEATURE);
    }};

    public static ArgsMap<ExtendedBugReport.State> extendedBugReportStates = new ArgsMap<ExtendedBugReport.State>() {{
        put("ExtendedBugReportMode.enabledWithRequiredFields", ExtendedBugReport.State.ENABLED_WITH_REQUIRED_FIELDS);
        put("ExtendedBugReportMode.enabledWithOptionalFields", ExtendedBugReport.State.ENABLED_WITH_OPTIONAL_FIELDS);
        put("ExtendedBugReportMode.disabled", ExtendedBugReport.State.DISABLED);
    }};

    public static final ArgsMap<Integer> reproModes = new ArgsMap<Integer>() {{
        put("ReproStepsMode.enabledWithNoScreenshots", ReproMode.EnableWithNoScreenshots);
        put("ReproStepsMode.enabled", ReproMode.EnableWithScreenshots);
        put("ReproStepsMode.disabled", ReproMode.Disable);
    }};

    public static final ArgsMap<InstabugLocale> locales = new ArgsMap<InstabugLocale>() {{
        put("IBGLocale.arabic", InstabugLocale.ARABIC);
        put("IBGLocale.azerbaijani", InstabugLocale.AZERBAIJANI);
        put("IBGLocale.chineseSimplified", InstabugLocale.SIMPLIFIED_CHINESE);
        put("IBGLocale.chineseTraditional", InstabugLocale.TRADITIONAL_CHINESE);
        put("IBGLocale.czech", InstabugLocale.CZECH);
        put("IBGLocale.danish", InstabugLocale.DANISH);
        put("IBGLocale.dutch", InstabugLocale.NETHERLANDS);
        put("IBGLocale.english", InstabugLocale.ENGLISH);
        put("IBGLocale.finnish", InstabugLocale.FINNISH);
        put("IBGLocale.french", InstabugLocale.FRENCH);
        put("IBGLocale.german", InstabugLocale.GERMAN);
        put("IBGLocale.hungarian", InstabugLocale.HUNGARIAN);
        put("IBGLocale.indonesian", InstabugLocale.INDONESIAN);
        put("IBGLocale.italian", InstabugLocale.ITALIAN);
        put("IBGLocale.japanese", InstabugLocale.JAPANESE);
        put("IBGLocale.korean", InstabugLocale.KOREAN);
        put("IBGLocale.norwegian", InstabugLocale.NORWEGIAN);
        put("IBGLocale.polish", InstabugLocale.POLISH);
        put("IBGLocale.portugueseBrazil", InstabugLocale.PORTUGUESE_BRAZIL);
        put("IBGLocale.portuguesePortugal", InstabugLocale.PORTUGUESE_PORTUGAL);
        put("IBGLocale.romanian", InstabugLocale.ROMANIAN);
        put("IBGLocale.russian", InstabugLocale.RUSSIAN);
        put("IBGLocale.slovak", InstabugLocale.SLOVAK);
        put("IBGLocale.spanish", InstabugLocale.SPANISH);
        put("IBGLocale.swedish", InstabugLocale.SWEDISH);
        put("IBGLocale.turkish", InstabugLocale.TURKISH);
    }};

    public static final ArgsMap<Key> placeholders = new ArgsMap<Key>() {{
        put("CustomTextPlaceHolderKey.shakeHint", Key.SHAKE_HINT);
        put("CustomTextPlaceHolderKey.swipeHint", Key.SWIPE_HINT);
        put("CustomTextPlaceHolderKey.invalidEmailMessage", Key.INVALID_EMAIL_MESSAGE);
        put("CustomTextPlaceHolderKey.emailFieldHint", Key.EMAIL_FIELD_HINT);
        put("CustomTextPlaceHolderKey.commentFieldHintForBugReport", Key.COMMENT_FIELD_HINT_FOR_BUG_REPORT);
        put("CustomTextPlaceHolderKey.commentFieldHintForFeedback", Key.COMMENT_FIELD_HINT_FOR_FEEDBACK);
        put("CustomTextPlaceHolderKey.commentFieldHintForQuestion", Key.COMMENT_FIELD_HINT_FOR_QUESTION);
        put("CustomTextPlaceHolderKey.invocationHeader", Key.INVOCATION_HEADER);
        put("CustomTextPlaceHolderKey.reportQuestion", Key.REPORT_QUESTION);
        put("CustomTextPlaceHolderKey.reportBug", Key.REPORT_BUG);
        put("CustomTextPlaceHolderKey.reportFeedback", Key.REPORT_FEEDBACK);
        put("CustomTextPlaceHolderKey.conversationsListTitle", Key.CONVERSATIONS_LIST_TITLE);
        put("CustomTextPlaceHolderKey.addVoiceMessage", Key.ADD_VOICE_MESSAGE);
        put("CustomTextPlaceHolderKey.addImageFromGallery", Key.ADD_IMAGE_FROM_GALLERY);
        put("CustomTextPlaceHolderKey.addExtraScreenshot", Key.ADD_EXTRA_SCREENSHOT);
        put("CustomTextPlaceHolderKey.addVideo", Key.ADD_VIDEO);
        put("CustomTextPlaceHolderKey.audioRecordingPermissionDenied", Key.AUDIO_RECORDING_PERMISSION_DENIED);
        put("CustomTextPlaceHolderKey.voiceMessagePressAndHoldToRecord", Key.VOICE_MESSAGE_PRESS_AND_HOLD_TO_RECORD);
        put("CustomTextPlaceHolderKey.voiceMessageReleaseToAttach", Key.VOICE_MESSAGE_RELEASE_TO_ATTACH);
        put("CustomTextPlaceHolderKey.successDialogHeader", Key.SUCCESS_DIALOG_HEADER);
        put("CustomTextPlaceHolderKey.videoPressRecord", Key.VIDEO_RECORDING_FAB_BUBBLE_HINT);
        put("CustomTextPlaceHolderKey.conversationTextFieldHint", Key.CONVERSATION_TEXT_FIELD_HINT);
        put("CustomTextPlaceHolderKey.reportSuccessfullySent", Key.REPORT_SUCCESSFULLY_SENT);

        put("CustomTextPlaceHolderKey.betaWelcomeMessageWelcomeStepTitle", Key.BETA_WELCOME_MESSAGE_WELCOME_STEP_TITLE);
        put("CustomTextPlaceHolderKey.betaWelcomeMessageWelcomeStepContent", Key.BETA_WELCOME_MESSAGE_WELCOME_STEP_CONTENT);
        put("CustomTextPlaceHolderKey.betaWelcomeMessageHowToReportStepTitle", Key.BETA_WELCOME_MESSAGE_HOW_TO_REPORT_STEP_TITLE);
        put("CustomTextPlaceHolderKey.betaWelcomeMessageHowToReportStepContent", Key.BETA_WELCOME_MESSAGE_HOW_TO_REPORT_STEP_CONTENT);
        put("CustomTextPlaceHolderKey.betaWelcomeMessageFinishStepTitle", Key.BETA_WELCOME_MESSAGE_FINISH_STEP_TITLE);
        put("CustomTextPlaceHolderKey.betaWelcomeMessageFinishStepContent", Key.BETA_WELCOME_MESSAGE_FINISH_STEP_CONTENT);
        put("CustomTextPlaceHolderKey.liveWelcomeMessageTitle", Key.LIVE_WELCOME_MESSAGE_TITLE);
        put("CustomTextPlaceHolderKey.liveWelcomeMessageContent", Key.LIVE_WELCOME_MESSAGE_CONTENT);

        put("CustomTextPlaceHolderKey.surveysStoreRatingThanksTitle", Key.SURVEYS_STORE_RATING_THANKS_TITLE);
        put("CustomTextPlaceHolderKey.surveysStoreRatingThanksSubtitle", Key.SURVEYS_STORE_RATING_THANKS_SUBTITLE);

        put("CustomTextPlaceHolderKey.reportBugDescription", Key.REPORT_BUG_DESCRIPTION);
        put("CustomTextPlaceHolderKey.reportFeedbackDescription", Key.REPORT_FEEDBACK_DESCRIPTION);
        put("CustomTextPlaceHolderKey.reportQuestionDescription", Key.REPORT_QUESTION_DESCRIPTION);
        put("CustomTextPlaceHolderKey.requestFeatureDescription", Key.REQUEST_FEATURE_DESCRIPTION);

        put("CustomTextPlaceHolderKey.discardAlertTitle", Key.REPORT_DISCARD_DIALOG_TITLE);
        put("CustomTextPlaceHolderKey.discardAlertMessage", Key.REPORT_DISCARD_DIALOG_BODY);
        put("CustomTextPlaceHolderKey.discardAlertCancel", Key.REPORT_DISCARD_DIALOG_NEGATIVE_ACTION);
        put("CustomTextPlaceHolderKey.discardAlertAction", Key.REPORT_DISCARD_DIALOG_POSITIVE_ACTION);
        put("CustomTextPlaceHolderKey.addAttachmentButtonTitleStringName", Key.REPORT_ADD_ATTACHMENT_HEADER);

        put("CustomTextPlaceHolderKey.reportReproStepsDisclaimerBody", Key.REPORT_REPRO_STEPS_DISCLAIMER_BODY);
        put("CustomTextPlaceHolderKey.reportReproStepsDisclaimerLink", Key.REPORT_REPRO_STEPS_DISCLAIMER_LINK);
        put("CustomTextPlaceHolderKey.reproStepsProgressDialogBody", Key.REPRO_STEPS_PROGRESS_DIALOG_BODY);
        put("CustomTextPlaceHolderKey.reproStepsListHeader", Key.REPRO_STEPS_LIST_HEADER);
        put("CustomTextPlaceHolderKey.reproStepsListDescription", Key.REPRO_STEPS_LIST_DESCRIPTION);
        put("CustomTextPlaceHolderKey.reproStepsListEmptyStateDescription", Key.REPRO_STEPS_LIST_EMPTY_STATE_DESCRIPTION);
        put("CustomTextPlaceHolderKey.reproStepsListItemTitle", Key.REPRO_STEPS_LIST_ITEM_NUMBERING_TITLE);

        put("CustomTextPlaceHolderKey.repliesNotificationTeamName", Key.CHATS_TEAM_STRING_NAME);
        put("CustomTextPlaceHolderKey.repliesNotificationReplyButton", Key.REPLIES_NOTIFICATION_REPLY_BUTTON);
        put("CustomTextPlaceHolderKey.repliesNotificationDismissButton", Key.REPLIES_NOTIFICATION_DISMISS_BUTTON);

        put("CustomTextPlaceHolderKey.okButtonText", Key.BUG_ATTACHMENT_DIALOG_OK_BUTTON);
        put("CustomTextPlaceHolderKey.audio", Key.CHATS_TYPE_AUDIO);
        put("CustomTextPlaceHolderKey.image", Key.CHATS_TYPE_IMAGE);
        put("CustomTextPlaceHolderKey.screenRecording", Key.CHATS_TYPE_VIDEO);
        put("CustomTextPlaceHolderKey.messagesNotificationAndOthers", Key.CHATS_MULTIPLE_MESSAGE_NOTIFICATION);
        put("CustomTextPlaceHolderKey.insufficientContentMessage", Key.COMMENT_FIELD_INSUFFICIENT_CONTENT);
    }};

    public static final ArgsMap<String> gestureStepType = new ArgsMap<String>() {{
        put("GestureType.swipe", StepType.SWIPE);
        put("GestureType.scroll", StepType.SCROLL);
        put("GestureType.tap", StepType.TAP);
        put("GestureType.pinch", StepType.PINCH);
        put("GestureType.longPress", StepType.LONG_PRESS);
        put("GestureType.doubleTap", StepType.DOUBLE_TAP);
    }};
}
