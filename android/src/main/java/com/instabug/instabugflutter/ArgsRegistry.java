package com.instabug.instabugflutter;

import com.instabug.bug.BugReporting;
import com.instabug.bug.invocation.Option;
import com.instabug.library.InstabugColorTheme;
import com.instabug.library.InstabugCustomTextPlaceHolder;

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
        registerInvocationModeArgs(ARGS);
        registerInvocationOptionsArgs(ARGS);
        registerCustomTextPlaceHolderKeysArgs(ARGS);
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

    static void registerInvocationModeArgs(Map<String, Object> args) {
        args.put("InvocationMode.BUG", BugReporting.ReportType.BUG);
        args.put("InvocationMode.FEEDBACK", BugReporting.ReportType.FEEDBACK);
    }

    static void registerInvocationOptionsArgs(Map<String, Object> args) {
        args.put("InvocationOption.COMMENT_FIELD_REQUIRED", Option.COMMENT_FIELD_REQUIRED);
        args.put("InvocationOption.DISABLE_POST_SENDING_DIALOG", Option.DISABLE_POST_SENDING_DIALOG);
        args.put("InvocationOption.EMAIL_FIELD_HIDDEN", Option.EMAIL_FIELD_HIDDEN);
        args.put("InvocationOption.EMAIL_FIELD_OPTIONAL", Option.EMAIL_FIELD_OPTIONAL);
    }

    static void registerLocaleArgs(Map<String, Object> args) {
        args.put("Locale.ChineseTraditional", new Locale(TRADITIONAL_CHINESE.getCode(), TRADITIONAL_CHINESE.getCountry()));
        args.put("Locale.PortuguesePortugal", new Locale(PORTUGUESE_PORTUGAL.getCode(), PORTUGUESE_PORTUGAL.getCountry()));
        args.put("Locale.ChineseSimplified", new Locale(SIMPLIFIED_CHINESE.getCode(), SIMPLIFIED_CHINESE.getCountry()));
        args.put("Locale.PortugueseBrazil", new Locale(PORTUGUESE_BRAZIL.getCode(), PORTUGUESE_BRAZIL.getCountry()));
        args.put("Locale.Indonesian", new Locale(INDONESIAN.getCode(), INDONESIAN.getCountry()));
        args.put("Locale.Dutch", new Locale(NETHERLANDS.getCode(), NETHERLANDS.getCountry()));
        args.put("Locale.Norwegian", new Locale(NORWEGIAN.getCode(), NORWEGIAN.getCountry()));
        args.put("Locale.Japanese", new Locale(JAPANESE.getCode(), JAPANESE.getCountry()));
        args.put("Locale.English", new Locale(ENGLISH.getCode(), ENGLISH.getCountry()));
        args.put("Locale.Italian", new Locale(ITALIAN.getCode(), ITALIAN.getCountry()));
        args.put("Locale.Russian", new Locale(RUSSIAN.getCode(), RUSSIAN.getCountry()));
        args.put("Locale.Spanish", new Locale(SPANISH.getCode(), SPANISH.getCountry()));
        args.put("Locale.Swedish", new Locale(SWEDISH.getCode(), SWEDISH.getCountry()));
        args.put("Locale.Turkish", new Locale(TURKISH.getCode(), TURKISH.getCountry()));
        args.put("Locale.Arabic", new Locale(ARABIC.getCode(), ARABIC.getCountry()));
        args.put("Locale.Danish", new Locale(DANISH.getCode(), DANISH.getCountry()));
        args.put("Locale.French", new Locale(FRENCH.getCode(), FRENCH.getCountry()));
        args.put("Locale.German", new Locale(GERMAN.getCode(), GERMAN.getCountry()));
        args.put("Locale.Korean", new Locale(KOREAN.getCode(), KOREAN.getCountry()));
        args.put("Locale.Polish", new Locale(POLISH.getCode(), POLISH.getCountry()));
        args.put("Locale.Slovak", new Locale(SLOVAK.getCode(), SLOVAK.getCountry()));
        args.put("Locale.Czech", new Locale(CZECH.getCode(), CZECH.getCountry()));
    }

    static void registerCustomTextPlaceHolderKeysArgs(Map<String, Object> args) {
        args.put("IBGCustomTextPlaceHolderKey.SHAKE_HINT", InstabugCustomTextPlaceHolder.Key.SHAKE_HINT);
        args.put("IBGCustomTextPlaceHolderKey.SWIPE_HINT", InstabugCustomTextPlaceHolder.Key.SWIPE_HINT);
        args.put("IBGCustomTextPlaceHolderKey.INVALID_EMAIL_MESSAGE", InstabugCustomTextPlaceHolder.Key.INVALID_EMAIL_MESSAGE);
        args.put("IBGCustomTextPlaceHolderKey.INVALID_COMMENT_MESSAGE", InstabugCustomTextPlaceHolder.Key.INVALID_COMMENT_MESSAGE);
        args.put("IBGCustomTextPlaceHolderKey.INVOCATION_HEADER", InstabugCustomTextPlaceHolder.Key.INVOCATION_HEADER);
        args.put("IBGCustomTextPlaceHolderKey.START_CHATS", InstabugCustomTextPlaceHolder.Key.START_CHATS);
        args.put("IBGCustomTextPlaceHolderKey.REPORT_BUG", InstabugCustomTextPlaceHolder.Key.REPORT_BUG);
        args.put("IBGCustomTextPlaceHolderKey.REPORT_FEEDBACK", InstabugCustomTextPlaceHolder.Key.REPORT_FEEDBACK);
        args.put("IBGCustomTextPlaceHolderKey.EMAIL_FIELD_HINT", InstabugCustomTextPlaceHolder.Key.EMAIL_FIELD_HINT);
        args.put("IBGCustomTextPlaceHolderKey.COMMENT_FIELD_HINT_FOR_BUG_REPORT", InstabugCustomTextPlaceHolder.Key.COMMENT_FIELD_HINT_FOR_BUG_REPORT);
        args.put("IBGCustomTextPlaceHolderKey.COMMENT_FIELD_HINT_FOR_FEEDBACK", InstabugCustomTextPlaceHolder.Key.COMMENT_FIELD_HINT_FOR_FEEDBACK);
        args.put("IBGCustomTextPlaceHolderKey.ADD_VOICE_MESSAGE", InstabugCustomTextPlaceHolder.Key.ADD_VOICE_MESSAGE);
        args.put("IBGCustomTextPlaceHolderKey.ADD_IMAGE_FROM_GALLERY", InstabugCustomTextPlaceHolder.Key.ADD_IMAGE_FROM_GALLERY);
        args.put("IBGCustomTextPlaceHolderKey.ADD_EXTRA_SCREENSHOT", InstabugCustomTextPlaceHolder.Key.ADD_EXTRA_SCREENSHOT);
        args.put("IBGCustomTextPlaceHolderKey.CONVERSATIONS_LIST_TITLE", InstabugCustomTextPlaceHolder.Key.CONVERSATIONS_LIST_TITLE);
        args.put("IBGCustomTextPlaceHolderKey.AUDIO_RECORDING_PERMISSION_DENIED", InstabugCustomTextPlaceHolder.Key.AUDIO_RECORDING_PERMISSION_DENIED);
        args.put("IBGCustomTextPlaceHolderKey.CONVERSATION_TEXT_FIELD_HINT", InstabugCustomTextPlaceHolder.Key.CONVERSATION_TEXT_FIELD_HINT);
        args.put("IBGCustomTextPlaceHolderKey.BUG_REPORT_HEADER", InstabugCustomTextPlaceHolder.Key.BUG_REPORT_HEADER);
        args.put("IBGCustomTextPlaceHolderKey.FEEDBACK_REPORT_HEADER", InstabugCustomTextPlaceHolder.Key.FEEDBACK_REPORT_HEADER);
        args.put("IBGCustomTextPlaceHolderKey.VOICE_MESSAGE_PRESS_AND_HOLD_TO_RECORD", InstabugCustomTextPlaceHolder.Key.VOICE_MESSAGE_PRESS_AND_HOLD_TO_RECORD);
        args.put("IBGCustomTextPlaceHolderKey.VOICE_MESSAGE_RELEASE_TO_ATTACH", InstabugCustomTextPlaceHolder.Key.VOICE_MESSAGE_RELEASE_TO_ATTACH);
        args.put("IBGCustomTextPlaceHolderKey.REPORT_SUCCESSFULLY_SENT", InstabugCustomTextPlaceHolder.Key.REPORT_SUCCESSFULLY_SENT);
        args.put("IBGCustomTextPlaceHolderKey.SUCCESS_DIALOG_HEADER", InstabugCustomTextPlaceHolder.Key.SUCCESS_DIALOG_HEADER);
        args.put("IBGCustomTextPlaceHolderKey.ADD_VIDEO", InstabugCustomTextPlaceHolder.Key.ADD_VIDEO);
        args.put("IBGCustomTextPlaceHolderKey.BETA_WELCOME_MESSAGE_WELCOME_STEP_TITLE", InstabugCustomTextPlaceHolder.Key.BETA_WELCOME_MESSAGE_WELCOME_STEP_TITLE);
        args.put("IBGCustomTextPlaceHolderKey.BETA_WELCOME_MESSAGE_WELCOME_STEP_CONTENT", InstabugCustomTextPlaceHolder.Key.BETA_WELCOME_MESSAGE_WELCOME_STEP_CONTENT);
        args.put("IBGCustomTextPlaceHolderKey.BETA_WELCOME_MESSAGE_HOW_TO_REPORT_STEP_TITLE", InstabugCustomTextPlaceHolder.Key.BETA_WELCOME_MESSAGE_HOW_TO_REPORT_STEP_TITLE);
        args.put("IBGCustomTextPlaceHolderKey.BETA_WELCOME_MESSAGE_HOW_TO_REPORT_STEP_CONTENT", InstabugCustomTextPlaceHolder.Key.BETA_WELCOME_MESSAGE_HOW_TO_REPORT_STEP_CONTENT);
        args.put("IBGCustomTextPlaceHolderKey.BETA_WELCOME_MESSAGE_FINISH_STEP_TITLE", InstabugCustomTextPlaceHolder.Key.BETA_WELCOME_MESSAGE_FINISH_STEP_TITLE);
        args.put("IBGCustomTextPlaceHolderKey.BETA_WELCOME_MESSAGE_FINISH_STEP_CONTENT", InstabugCustomTextPlaceHolder.Key.BETA_WELCOME_MESSAGE_FINISH_STEP_CONTENT);
        args.put("IBGCustomTextPlaceHolderKey.LIVE_WELCOME_MESSAGE_TITLE", InstabugCustomTextPlaceHolder.Key.LIVE_WELCOME_MESSAGE_TITLE);
        args.put("IBGCustomTextPlaceHolderKey.LIVE_WELCOME_MESSAGE_CONTENT", InstabugCustomTextPlaceHolder.Key.LIVE_WELCOME_MESSAGE_CONTENT);
    }
}
