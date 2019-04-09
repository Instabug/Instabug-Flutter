package com.instabug.instabugflutter;

import android.support.annotation.Nullable;
import android.support.annotation.VisibleForTesting;

import com.instabug.bug.BugReporting;
import com.instabug.bug.invocation.Option;
import com.instabug.library.InstabugColorTheme;
import com.instabug.library.InstabugCustomTextPlaceHolder;
import com.instabug.library.extendedbugreport.ExtendedBugReport;

import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import static com.instabug.library.internal.module.InstabugLocale.ARABIC;
import static com.instabug.library.internal.module.InstabugLocale.CZECH;
import static com.instabug.library.internal.module.InstabugLocale.DANISH;
import static com.instabug.library.internal.module.InstabugLocale.ENGLISH;
import static com.instabug.library.internal.module.InstabugLocale.FRENCH;
import static com.instabug.library.internal.module.InstabugLocale.GERMAN;
import static com.instabug.library.internal.module.InstabugLocale.INDONESIAN;
import static com.instabug.library.internal.module.InstabugLocale.ITALIAN;
import static com.instabug.library.internal.module.InstabugLocale.JAPANESE;
import static com.instabug.library.internal.module.InstabugLocale.KOREAN;
import static com.instabug.library.internal.module.InstabugLocale.NETHERLANDS;
import static com.instabug.library.internal.module.InstabugLocale.NORWEGIAN;
import static com.instabug.library.internal.module.InstabugLocale.POLISH;
import static com.instabug.library.internal.module.InstabugLocale.PORTUGUESE_BRAZIL;
import static com.instabug.library.internal.module.InstabugLocale.PORTUGUESE_PORTUGAL;
import static com.instabug.library.internal.module.InstabugLocale.RUSSIAN;
import static com.instabug.library.internal.module.InstabugLocale.SIMPLIFIED_CHINESE;
import static com.instabug.library.internal.module.InstabugLocale.SLOVAK;
import static com.instabug.library.internal.module.InstabugLocale.SPANISH;
import static com.instabug.library.internal.module.InstabugLocale.SWEDISH;
import static com.instabug.library.internal.module.InstabugLocale.TRADITIONAL_CHINESE;
import static com.instabug.library.internal.module.InstabugLocale.TURKISH;
import static com.instabug.library.invocation.InstabugInvocationEvent.FLOATING_BUTTON;
import static com.instabug.library.invocation.InstabugInvocationEvent.NONE;
import static com.instabug.library.invocation.InstabugInvocationEvent.SCREENSHOT;
import static com.instabug.library.invocation.InstabugInvocationEvent.SHAKE;
import static com.instabug.library.invocation.InstabugInvocationEvent.TWO_FINGER_SWIPE_LEFT;
import static com.instabug.library.ui.onboarding.WelcomeMessage.State.BETA;
import static com.instabug.library.ui.onboarding.WelcomeMessage.State.DISABLED;
import static com.instabug.library.ui.onboarding.WelcomeMessage.State.LIVE;

@SuppressWarnings({"SameParameterValue", "unchecked"})
final class ArgsRegistry {

    @VisibleForTesting
    static final Map<String, Object> ARGS = new HashMap<>();

    static {
        registerInstabugInvocationEventsArgs(ARGS);
        registerWelcomeMessageArgs(ARGS);
        registerColorThemeArgs(ARGS);
        registerLocaleArgs(ARGS);
        registerInvocationModeArgs(ARGS);
        registerInvocationOptionsArgs(ARGS);
        registerCustomTextPlaceHolderKeysArgs(ARGS);
        registerInstabugReportTypesArgs(ARGS);
        registerInstabugExtendedBugReportModeArgs(ARGS);
    }

    /**
     * This acts as a safe get() method.
     * It returns the queried value after deserialization if AND ONLY IF it passed the following assertions:
     * - {@code key} is not null
     * - {@code key} does exist in the registry
     * - The value assigned to the {@code key} is not null
     * - The value assigned to the {@code key} is assignable from and can be casted to {@code clazz}
     * (i.e. Foo value = getDeserializedValue("key", Foo.class))
     *
     * @param key   the key whose associated value is to be returned
     * @param clazz the type in which the value should be deserialized to
     * @return the value deserialized if all the assertions were successful, null otherwise
     */
    @Nullable
    static <T> T getDeserializedValue(String key, Class<T> clazz) {
        if (key != null && ARGS.containsKey(key)) {
            Object constant = ARGS.get(key);
            if (constant != null && constant.getClass().isAssignableFrom(clazz)) {
                return (T) constant;
            }
        }
        return null;
    }

    /**
     * This acts as a safe get() method.
     * It returns the queried raw value if AND ONLY IF it passed the following assertions:
     * - {@code key} is not null
     * - {@code key} does exist in the registry
     * (i.e. Object value = getRawValue("key")
     *
     * @param key the key whose associated value is to be returned
     * @return the value  if all the assertions were successful, null otherwise
     */
    @Nullable
    static Object getRawValue(String key) {
        if (key != null) {
            return ARGS.get(key);
        }
        return null;
    }

    @VisibleForTesting
    static void registerInstabugInvocationEventsArgs(Map<String, Object> args) {
        args.put("InvocationEvent.twoFingersSwipeLeft", TWO_FINGER_SWIPE_LEFT);
        args.put("InvocationEvent.floatingButton", FLOATING_BUTTON);
        args.put("InvocationEvent.screenshot", SCREENSHOT);
        args.put("InvocationEvent.shake", SHAKE);
        args.put("InvocationEvent.none", NONE);
    }

    @VisibleForTesting
    static void registerWelcomeMessageArgs(Map<String, Object> args) {
        args.put("WelcomeMessageMode.disabled", DISABLED);
        args.put("WelcomeMessageMode.live", LIVE);
        args.put("WelcomeMessageMode.beta", BETA);
    }

    @VisibleForTesting
    static void registerColorThemeArgs(Map<String, Object> args) {
        args.put("ColorTheme.light", InstabugColorTheme.InstabugColorThemeLight);
        args.put("ColorTheme.dark", InstabugColorTheme.InstabugColorThemeDark);
    }

    @VisibleForTesting
    static void registerInvocationModeArgs(Map<String, Object> args) {
        args.put("InvocationMode.bug", BugReporting.ReportType.BUG);
        args.put("InvocationMode.feedback", BugReporting.ReportType.FEEDBACK);
    }

    @VisibleForTesting
    static void registerInvocationOptionsArgs(Map<String, Object> args) {
        args.put("InvocationOption.commentFieldRequired", Option.COMMENT_FIELD_REQUIRED);
        args.put("InvocationOption.disablePostSendingDialog", Option.DISABLE_POST_SENDING_DIALOG);
        args.put("InvocationOption.emailFieldHidden", Option.EMAIL_FIELD_HIDDEN);
        args.put("InvocationOption.emailFieldOptional", Option.EMAIL_FIELD_OPTIONAL);
    }

    @VisibleForTesting
    static void registerLocaleArgs(Map<String, Object> args) {
        args.put("Locale.chineseTraditional", new Locale(TRADITIONAL_CHINESE.getCode(), TRADITIONAL_CHINESE.getCountry()));
        args.put("Locale.portuguesePortugal", new Locale(PORTUGUESE_PORTUGAL.getCode(), PORTUGUESE_PORTUGAL.getCountry()));
        args.put("Locale.chineseSimplified", new Locale(SIMPLIFIED_CHINESE.getCode(), SIMPLIFIED_CHINESE.getCountry()));
        args.put("Locale.portugueseBrazil", new Locale(PORTUGUESE_BRAZIL.getCode(), PORTUGUESE_BRAZIL.getCountry()));
        args.put("Locale.indonesian", new Locale(INDONESIAN.getCode(), INDONESIAN.getCountry()));
        args.put("Locale.dutch", new Locale(NETHERLANDS.getCode(), NETHERLANDS.getCountry()));
        args.put("Locale.norwegian", new Locale(NORWEGIAN.getCode(), NORWEGIAN.getCountry()));
        args.put("Locale.japanese", new Locale(JAPANESE.getCode(), JAPANESE.getCountry()));
        args.put("Locale.english", new Locale(ENGLISH.getCode(), ENGLISH.getCountry()));
        args.put("Locale.italian", new Locale(ITALIAN.getCode(), ITALIAN.getCountry()));
        args.put("Locale.russian", new Locale(RUSSIAN.getCode(), RUSSIAN.getCountry()));
        args.put("Locale.spanish", new Locale(SPANISH.getCode(), SPANISH.getCountry()));
        args.put("Locale.swedish", new Locale(SWEDISH.getCode(), SWEDISH.getCountry()));
        args.put("Locale.turkish", new Locale(TURKISH.getCode(), TURKISH.getCountry()));
        args.put("Locale.arabic", new Locale(ARABIC.getCode(), ARABIC.getCountry()));
        args.put("Locale.danish", new Locale(DANISH.getCode(), DANISH.getCountry()));
        args.put("Locale.french", new Locale(FRENCH.getCode(), FRENCH.getCountry()));
        args.put("Locale.german", new Locale(GERMAN.getCode(), GERMAN.getCountry()));
        args.put("Locale.korean", new Locale(KOREAN.getCode(), KOREAN.getCountry()));
        args.put("Locale.polish", new Locale(POLISH.getCode(), POLISH.getCountry()));
        args.put("Locale.slovak", new Locale(SLOVAK.getCode(), SLOVAK.getCountry()));
        args.put("Locale.czech", new Locale(CZECH.getCode(), CZECH.getCountry()));
    }

    @VisibleForTesting
    static void registerCustomTextPlaceHolderKeysArgs(Map<String, Object> args) {
        args.put("IBGCustomTextPlaceHolderKey.shakeHint", InstabugCustomTextPlaceHolder.Key.SHAKE_HINT);
        args.put("IBGCustomTextPlaceHolderKey.swipeHint", InstabugCustomTextPlaceHolder.Key.SWIPE_HINT);
        args.put("IBGCustomTextPlaceHolderKey.invalidEmailMessage", InstabugCustomTextPlaceHolder.Key.INVALID_EMAIL_MESSAGE);
        args.put("IBGCustomTextPlaceHolderKey.invalidCommentMessage", InstabugCustomTextPlaceHolder.Key.INVALID_COMMENT_MESSAGE);
        args.put("IBGCustomTextPlaceHolderKey.invocationHeader", InstabugCustomTextPlaceHolder.Key.INVOCATION_HEADER);
        args.put("IBGCustomTextPlaceHolderKey.startChats", InstabugCustomTextPlaceHolder.Key.START_CHATS);
        args.put("IBGCustomTextPlaceHolderKey.reportBug", InstabugCustomTextPlaceHolder.Key.REPORT_BUG);
        args.put("IBGCustomTextPlaceHolderKey.reportFeedback", InstabugCustomTextPlaceHolder.Key.REPORT_FEEDBACK);
        args.put("IBGCustomTextPlaceHolderKey.emailFieldHint", InstabugCustomTextPlaceHolder.Key.EMAIL_FIELD_HINT);
        args.put("IBGCustomTextPlaceHolderKey.commentFieldHintForBugReport", InstabugCustomTextPlaceHolder.Key.COMMENT_FIELD_HINT_FOR_BUG_REPORT);
        args.put("IBGCustomTextPlaceHolderKey.commentFieldHintForFeedback", InstabugCustomTextPlaceHolder.Key.COMMENT_FIELD_HINT_FOR_FEEDBACK);
        args.put("IBGCustomTextPlaceHolderKey.addVoiceMessage", InstabugCustomTextPlaceHolder.Key.ADD_VOICE_MESSAGE);
        args.put("IBGCustomTextPlaceHolderKey.addImageFromGallery", InstabugCustomTextPlaceHolder.Key.ADD_IMAGE_FROM_GALLERY);
        args.put("IBGCustomTextPlaceHolderKey.addExtraScreenshot", InstabugCustomTextPlaceHolder.Key.ADD_EXTRA_SCREENSHOT);
        args.put("IBGCustomTextPlaceHolderKey.conversationsListTitle", InstabugCustomTextPlaceHolder.Key.CONVERSATIONS_LIST_TITLE);
        args.put("IBGCustomTextPlaceHolderKey.audioRecordingPermissionDenied", InstabugCustomTextPlaceHolder.Key.AUDIO_RECORDING_PERMISSION_DENIED);
        args.put("IBGCustomTextPlaceHolderKey.conversationTextFieldHint", InstabugCustomTextPlaceHolder.Key.CONVERSATION_TEXT_FIELD_HINT);
        args.put("IBGCustomTextPlaceHolderKey.bugReportHeader", InstabugCustomTextPlaceHolder.Key.BUG_REPORT_HEADER);
        args.put("IBGCustomTextPlaceHolderKey.feedbackReportHeader", InstabugCustomTextPlaceHolder.Key.FEEDBACK_REPORT_HEADER);
        args.put("IBGCustomTextPlaceHolderKey.voiceMessagePressAndHoldToRecord", InstabugCustomTextPlaceHolder.Key.VOICE_MESSAGE_PRESS_AND_HOLD_TO_RECORD);
        args.put("IBGCustomTextPlaceHolderKey.voiceMessageReleaseToAttach", InstabugCustomTextPlaceHolder.Key.VOICE_MESSAGE_RELEASE_TO_ATTACH);
        args.put("IBGCustomTextPlaceHolderKey.reportSuccessfullySent", InstabugCustomTextPlaceHolder.Key.REPORT_SUCCESSFULLY_SENT);
        args.put("IBGCustomTextPlaceHolderKey.successDialogHeader", InstabugCustomTextPlaceHolder.Key.SUCCESS_DIALOG_HEADER);
        args.put("IBGCustomTextPlaceHolderKey.addVideo", InstabugCustomTextPlaceHolder.Key.ADD_VIDEO);
        args.put("IBGCustomTextPlaceHolderKey.betaWelcomeMessageWelcomeStepTitle", InstabugCustomTextPlaceHolder.Key.BETA_WELCOME_MESSAGE_WELCOME_STEP_TITLE);
        args.put("IBGCustomTextPlaceHolderKey.betaWelcomeMessageWelcomeStepContent", InstabugCustomTextPlaceHolder.Key.BETA_WELCOME_MESSAGE_WELCOME_STEP_CONTENT);
        args.put("IBGCustomTextPlaceHolderKey.betaWelcomeMessageHowToReportStepTitle", InstabugCustomTextPlaceHolder.Key.BETA_WELCOME_MESSAGE_HOW_TO_REPORT_STEP_TITLE);
        args.put("IBGCustomTextPlaceHolderKey.betaWelcomeMessageHowToReportStepContent", InstabugCustomTextPlaceHolder.Key.BETA_WELCOME_MESSAGE_HOW_TO_REPORT_STEP_CONTENT);
        args.put("IBGCustomTextPlaceHolderKey.betaWelcomeMessageFinishStepTitle", InstabugCustomTextPlaceHolder.Key.BETA_WELCOME_MESSAGE_FINISH_STEP_TITLE);
        args.put("IBGCustomTextPlaceHolderKey.betaWelcomeMessageFinishStepContent", InstabugCustomTextPlaceHolder.Key.BETA_WELCOME_MESSAGE_FINISH_STEP_CONTENT);
        args.put("IBGCustomTextPlaceHolderKey.liveWelcomeMessageTitle", InstabugCustomTextPlaceHolder.Key.LIVE_WELCOME_MESSAGE_TITLE);
        args.put("IBGCustomTextPlaceHolderKey.liveWelcomeMessageContent", InstabugCustomTextPlaceHolder.Key.LIVE_WELCOME_MESSAGE_CONTENT);
    }

    @VisibleForTesting
    static void registerInstabugReportTypesArgs(Map<String, Object> args) {
        args.put("ReportType.bug", BugReporting.ReportType.BUG);
        args.put("ReportType.feedback", BugReporting.ReportType.FEEDBACK);
    }

    @VisibleForTesting
    static void registerInstabugExtendedBugReportModeArgs(Map<String, Object> args) {
        args.put("ExtendedBugReportMode.enabledWithRequiredFields", ExtendedBugReport.State.ENABLED_WITH_REQUIRED_FIELDS);
        args.put("ExtendedBugReportMode.enabledWithOptionalFields", ExtendedBugReport.State.ENABLED_WITH_OPTIONAL_FIELDS);
        args.put("ExtendedBugReportMode.disabled",ExtendedBugReport.State.DISABLED);
    }
}
