package com.instabug.instabugflutter;

import android.support.annotation.Nullable;
import android.support.annotation.VisibleForTesting;

import com.instabug.library.InstabugColorTheme;

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
}