package com.instabug.instabugflutter;

import com.instabug.bug.BugReporting;
import com.instabug.bug.invocation.Option;
import com.instabug.featuresrequest.ActionType;
import com.instabug.library.InstabugColorTheme;
import com.instabug.library.InstabugCustomTextPlaceHolder;
import com.instabug.library.extendedbugreport.ExtendedBugReport;
import com.instabug.library.visualusersteps.State;

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

    static final Map<String, Object> ARGS = new HashMap<>();

    static {
        registerInstabugInvocationEventsArgs(ARGS);
        registerWelcomeMessageArgs(ARGS);
        registerColorThemeArgs(ARGS);
        registerLocaleArgs(ARGS);
        registerInvocationOptionsArgs(ARGS);
        registerCustomTextPlaceHolderKeysArgs(ARGS);
        registerInstabugReportTypesArgs(ARGS);
        registerInstabugExtendedBugReportModeArgs(ARGS);
        registerInstabugActionTypesArgs(ARGS);
        registerReproStepsModeArgs(ARGS);
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
    static Object getRawValue(String key) {
        if (key != null) {
            return ARGS.get(key);
        }
        return null;
    }

    static void registerInstabugInvocationEventsArgs(Map<String, Object> args) {
        args.put("InvocationEvent.twoFingersSwipeLeft", TWO_FINGER_SWIPE_LEFT);
        args.put("InvocationEvent.floatingButton", FLOATING_BUTTON);
        args.put("InvocationEvent.screenshot", SCREENSHOT);
        args.put("InvocationEvent.shake", SHAKE);
        args.put("InvocationEvent.none", NONE);
    }

    static void registerWelcomeMessageArgs(Map<String, Object> args) {
        args.put("WelcomeMessageMode.disabled", DISABLED);
        args.put("WelcomeMessageMode.live", LIVE);
        args.put("WelcomeMessageMode.beta", BETA);
    }

    static void registerColorThemeArgs(Map<String, Object> args) {
        args.put("ColorTheme.light", InstabugColorTheme.InstabugColorThemeLight);
        args.put("ColorTheme.dark", InstabugColorTheme.InstabugColorThemeDark);
    }

    static void registerInvocationOptionsArgs(Map<String, Object> args) {
        args.put("InvocationOption.commentFieldRequired", Option.COMMENT_FIELD_REQUIRED);
        args.put("InvocationOption.disablePostSendingDialog", Option.DISABLE_POST_SENDING_DIALOG);
        args.put("InvocationOption.emailFieldHidden", Option.EMAIL_FIELD_HIDDEN);
        args.put("InvocationOption.emailFieldOptional", Option.EMAIL_FIELD_OPTIONAL);
    }

    static void registerLocaleArgs(Map<String, Object> args) {
        args.put("IBGLocale.chineseTraditional", new Locale(TRADITIONAL_CHINESE.getCode(), TRADITIONAL_CHINESE.getCountry()));
        args.put("IBGLocale.portuguesePortugal", new Locale(PORTUGUESE_PORTUGAL.getCode(), PORTUGUESE_PORTUGAL.getCountry()));
        args.put("IBGLocale.chineseSimplified", new Locale(SIMPLIFIED_CHINESE.getCode(), SIMPLIFIED_CHINESE.getCountry()));
        args.put("IBGLocale.portugueseBrazil", new Locale(PORTUGUESE_BRAZIL.getCode(), PORTUGUESE_BRAZIL.getCountry()));
        args.put("IBGLocale.indonesian", new Locale(INDONESIAN.getCode(), INDONESIAN.getCountry()));
        args.put("IBGLocale.dutch", new Locale(NETHERLANDS.getCode(), NETHERLANDS.getCountry()));
        args.put("IBGLocale.norwegian", new Locale(NORWEGIAN.getCode(), NORWEGIAN.getCountry()));
        args.put("IBGLocale.japanese", new Locale(JAPANESE.getCode(), JAPANESE.getCountry()));
        args.put("IBGLocale.english", new Locale(ENGLISH.getCode(), ENGLISH.getCountry()));
        args.put("IBGLocale.italian", new Locale(ITALIAN.getCode(), ITALIAN.getCountry()));
        args.put("IBGLocale.russian", new Locale(RUSSIAN.getCode(), RUSSIAN.getCountry()));
        args.put("IBGLocale.spanish", new Locale(SPANISH.getCode(), SPANISH.getCountry()));
        args.put("IBGLocale.swedish", new Locale(SWEDISH.getCode(), SWEDISH.getCountry()));
        args.put("IBGLocale.turkish", new Locale(TURKISH.getCode(), TURKISH.getCountry()));
        args.put("IBGLocale.arabic", new Locale(ARABIC.getCode(), ARABIC.getCountry()));
        args.put("IBGLocale.danish", new Locale(DANISH.getCode(), DANISH.getCountry()));
        args.put("IBGLocale.french", new Locale(FRENCH.getCode(), FRENCH.getCountry()));
        args.put("IBGLocale.german", new Locale(GERMAN.getCode(), GERMAN.getCountry()));
        args.put("IBGLocale.korean", new Locale(KOREAN.getCode(), KOREAN.getCountry()));
        args.put("IBGLocale.polish", new Locale(POLISH.getCode(), POLISH.getCountry()));
        args.put("IBGLocale.slovak", new Locale(SLOVAK.getCode(), SLOVAK.getCountry()));
        args.put("IBGLocale.czech", new Locale(CZECH.getCode(), CZECH.getCountry()));
    }

    static void registerCustomTextPlaceHolderKeysArgs(Map<String, Object> args) {
        args.put("CustomTextPlaceHolderKey.shakeHint", InstabugCustomTextPlaceHolder.Key.SHAKE_HINT);
        args.put("CustomTextPlaceHolderKey.swipeHint", InstabugCustomTextPlaceHolder.Key.SWIPE_HINT);
        args.put("CustomTextPlaceHolderKey.invalidEmailMessage", InstabugCustomTextPlaceHolder.Key.INVALID_EMAIL_MESSAGE);
        args.put("CustomTextPlaceHolderKey.invalidCommentMessage", InstabugCustomTextPlaceHolder.Key.INVALID_COMMENT_MESSAGE);
        args.put("CustomTextPlaceHolderKey.invocationHeader", InstabugCustomTextPlaceHolder.Key.INVOCATION_HEADER);
        args.put("CustomTextPlaceHolderKey.startChats", InstabugCustomTextPlaceHolder.Key.START_CHATS);
        args.put("CustomTextPlaceHolderKey.reportQuestion", InstabugCustomTextPlaceHolder.Key.REPORT_QUESTION);
        args.put("CustomTextPlaceHolderKey.reportBug", InstabugCustomTextPlaceHolder.Key.REPORT_BUG);
        args.put("CustomTextPlaceHolderKey.reportFeedback", InstabugCustomTextPlaceHolder.Key.REPORT_FEEDBACK);
        args.put("CustomTextPlaceHolderKey.emailFieldHint", InstabugCustomTextPlaceHolder.Key.EMAIL_FIELD_HINT);
        args.put("CustomTextPlaceHolderKey.commentFieldHintForBugReport", InstabugCustomTextPlaceHolder.Key.COMMENT_FIELD_HINT_FOR_BUG_REPORT);
        args.put("CustomTextPlaceHolderKey.commentFieldHintForFeedback", InstabugCustomTextPlaceHolder.Key.COMMENT_FIELD_HINT_FOR_FEEDBACK);
        args.put("CustomTextPlaceHolderKey.commentFieldHintForQuestion", InstabugCustomTextPlaceHolder.Key.COMMENT_FIELD_HINT_FOR_QUESTION);
        args.put("CustomTextPlaceHolderKey.addVoiceMessage", InstabugCustomTextPlaceHolder.Key.ADD_VOICE_MESSAGE);
        args.put("CustomTextPlaceHolderKey.addImageFromGallery", InstabugCustomTextPlaceHolder.Key.ADD_IMAGE_FROM_GALLERY);
        args.put("CustomTextPlaceHolderKey.addExtraScreenshot", InstabugCustomTextPlaceHolder.Key.ADD_EXTRA_SCREENSHOT);
        args.put("CustomTextPlaceHolderKey.conversationsListTitle", InstabugCustomTextPlaceHolder.Key.CONVERSATIONS_LIST_TITLE);
        args.put("CustomTextPlaceHolderKey.audioRecordingPermissionDenied", InstabugCustomTextPlaceHolder.Key.AUDIO_RECORDING_PERMISSION_DENIED);
        args.put("CustomTextPlaceHolderKey.conversationTextFieldHint", InstabugCustomTextPlaceHolder.Key.CONVERSATION_TEXT_FIELD_HINT);
        args.put("CustomTextPlaceHolderKey.bugReportHeader", InstabugCustomTextPlaceHolder.Key.BUG_REPORT_HEADER);
        args.put("CustomTextPlaceHolderKey.feedbackReportHeader", InstabugCustomTextPlaceHolder.Key.FEEDBACK_REPORT_HEADER);
        args.put("CustomTextPlaceHolderKey.voiceMessagePressAndHoldToRecord", InstabugCustomTextPlaceHolder.Key.VOICE_MESSAGE_PRESS_AND_HOLD_TO_RECORD);
        args.put("CustomTextPlaceHolderKey.voiceMessageReleaseToAttach", InstabugCustomTextPlaceHolder.Key.VOICE_MESSAGE_RELEASE_TO_ATTACH);
        args.put("CustomTextPlaceHolderKey.reportSuccessfullySent", InstabugCustomTextPlaceHolder.Key.REPORT_SUCCESSFULLY_SENT);
        args.put("CustomTextPlaceHolderKey.successDialogHeader", InstabugCustomTextPlaceHolder.Key.SUCCESS_DIALOG_HEADER);
        args.put("CustomTextPlaceHolderKey.addVideo", InstabugCustomTextPlaceHolder.Key.ADD_VIDEO);
        args.put("CustomTextPlaceHolderKey.betaWelcomeMessageWelcomeStepTitle", InstabugCustomTextPlaceHolder.Key.BETA_WELCOME_MESSAGE_WELCOME_STEP_TITLE);
        args.put("CustomTextPlaceHolderKey.betaWelcomeMessageWelcomeStepContent", InstabugCustomTextPlaceHolder.Key.BETA_WELCOME_MESSAGE_WELCOME_STEP_CONTENT);
        args.put("CustomTextPlaceHolderKey.betaWelcomeMessageHowToReportStepTitle", InstabugCustomTextPlaceHolder.Key.BETA_WELCOME_MESSAGE_HOW_TO_REPORT_STEP_TITLE);
        args.put("CustomTextPlaceHolderKey.betaWelcomeMessageHowToReportStepContent", InstabugCustomTextPlaceHolder.Key.BETA_WELCOME_MESSAGE_HOW_TO_REPORT_STEP_CONTENT);
        args.put("CustomTextPlaceHolderKey.betaWelcomeMessageFinishStepTitle", InstabugCustomTextPlaceHolder.Key.BETA_WELCOME_MESSAGE_FINISH_STEP_TITLE);
        args.put("CustomTextPlaceHolderKey.betaWelcomeMessageFinishStepContent", InstabugCustomTextPlaceHolder.Key.BETA_WELCOME_MESSAGE_FINISH_STEP_CONTENT);
        args.put("CustomTextPlaceHolderKey.liveWelcomeMessageTitle", InstabugCustomTextPlaceHolder.Key.LIVE_WELCOME_MESSAGE_TITLE);
        args.put("CustomTextPlaceHolderKey.liveWelcomeMessageContent", InstabugCustomTextPlaceHolder.Key.LIVE_WELCOME_MESSAGE_CONTENT);
    }

    static void registerInstabugReportTypesArgs(Map<String, Object> args) {
        args.put("ReportType.bug", BugReporting.ReportType.BUG);
        args.put("ReportType.feedback", BugReporting.ReportType.FEEDBACK);
        args.put("ReportType.question", BugReporting.ReportType.QUESTION);
    }

    static void registerInstabugExtendedBugReportModeArgs(Map<String, Object> args) {
        args.put("ExtendedBugReportMode.enabledWithRequiredFields", ExtendedBugReport.State.ENABLED_WITH_REQUIRED_FIELDS);
        args.put("ExtendedBugReportMode.enabledWithOptionalFields", ExtendedBugReport.State.ENABLED_WITH_OPTIONAL_FIELDS);
        args.put("ExtendedBugReportMode.disabled",ExtendedBugReport.State.DISABLED);
    }

    static void registerInstabugActionTypesArgs(Map<String, Object> args) {
        args.put("ActionType.requestNewFeature",ActionType.REQUEST_NEW_FEATURE);
        args.put("ActionType.addCommentToFeature",ActionType.ADD_COMMENT_TO_FEATURE);
    }

    static void registerReproStepsModeArgs(Map<String, Object> args) {
        args.put("ReproStepsMode.enabled", State.ENABLED);
        args.put("ReproStepsMode.disabled", State.DISABLED);
        args.put("ReproStepsMode.enabledWithNoScreenshots",State.ENABLED_WITH_NO_SCREENSHOTS);
    }

}
