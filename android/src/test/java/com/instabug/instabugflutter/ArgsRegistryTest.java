package com.instabug.instabugflutter;

import com.instabug.bug.BugReporting;
import com.instabug.bug.invocation.Option;
import com.instabug.library.InstabugColorTheme;
import com.instabug.library.InstabugCustomTextPlaceHolder;
import com.instabug.library.invocation.InstabugInvocationEvent;
import com.instabug.library.ui.onboarding.WelcomeMessage;

import org.junit.Assert;
import org.junit.Ignore;
import org.junit.Test;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

public class ArgsRegistryTest {

    @Test
    public void given$registerInstabugInvocationEventsArgsIsCalledOnAMap_whenQuery_thenShouldMatchCriteria() {
        // given
        Map<String, Object> map = new HashMap<>();
        // when
        ArgsRegistry.registerInstabugInvocationEventsArgs(map);
        // then
        Assert.assertEquals(5, map.size());
        assertAllInvocationEventsArePresent(map);
    }

    @Test
    public void given$registerWelcomeMessageArgsIsCalledOnAMap_whenQuery_thenShouldMatchCriteria() {
        // given
        Map<String, Object> map = new HashMap<>();
        // when
        ArgsRegistry.registerWelcomeMessageArgs(map);
        // then
        Assert.assertEquals(3, map.size());
        assertAllWelcomeMessageStatesArePresent(map);
    }

    @Test
    public void given$registerLocaleArgsIsCalledOnAMap_whenQuery_thenShouldMatchCriteria() {
        // given
        Map<String, Object> map = new HashMap<>();
        // when
        ArgsRegistry.registerLocaleArgs(map);
        // then
        assertAllSupportedLocalesArePresent(map);
    }

    @Test
    public void given$ArgsRegistryIsInitialized_whenQuery_thenShouldMatchCriteria() {
        Map<String, Object> args = ArgsRegistry.ARGS;
        assertAllInvocationEventsArePresent(args);
        assertAllWelcomeMessageStatesArePresent(args);
        assertAllSupportedLocalesArePresent(args);
        assertAllColorThemesArePresent(args);
        assertAllInvocationModesArePresent(args);
        assertAllInvocationOptionsArePresent(args);
        assertAllSupportedCustomTextPlaceHolderKeysArePresent(args);
    }

    @Test
    public void givenFabInvocationIsPresent_when$getDeserializedValue_thenShouldReturnNonNullLocale() {
        // when
        InstabugInvocationEvent deserializedValue = ArgsRegistry.getDeserializedValue(
                "InvocationEvent.floatingButton", InstabugInvocationEvent.class);
        // then
        Assert.assertNotNull(deserializedValue);
        Assert.assertEquals(InstabugInvocationEvent.FLOATING_BUTTON, deserializedValue);
    }

    @Test
    public void givenWelcomeMessageBetaIsPresent_when$getDeserializedValue_thenShouldReturnNonNullLocale() {
        // when
        WelcomeMessage.State deserializedValue = ArgsRegistry.getDeserializedValue(
                "WelcomeMessageMode.beta", WelcomeMessage.State.class);
        // then
        Assert.assertNotNull(deserializedValue);
        Assert.assertEquals(WelcomeMessage.State.BETA, deserializedValue);
    }

    @Test
    public void givenEnglishLocaleIsPresent_when$getDeserializedValue_thenShouldReturnNonNullLocale() {
        // when
        Locale actualLocale = ArgsRegistry.getDeserializedValue("IBGLocale.english", Locale.class);
        // then
        Assert.assertNotNull(actualLocale);
        Assert.assertEquals("en", actualLocale.getLanguage());
    }

    @Test
    public void given$registerColorThemeArgsIsCalledOnAMap_whenQuery_thenShouldMatchCriteria() {
        // given
        Map<String, Object> map = new HashMap<>();
        // when
        ArgsRegistry.registerColorThemeArgs(map);
        // then
        assertAllColorThemesArePresent(map);
    }

    @Test
    public void givenShakeHintIsPresent_when$getDeserializedValue_thenShouldReturnNonNullKey() {
        // when
        InstabugCustomTextPlaceHolder.Key actualKey =
                ArgsRegistry.getDeserializedValue("CustomTextPlaceHolderKey.shakeHint", InstabugCustomTextPlaceHolder.Key.class);
        // then
        Assert.assertNotNull(actualKey);
        Assert.assertEquals(InstabugCustomTextPlaceHolder.Key.SHAKE_HINT, actualKey);

    }

    @Test
    public void given$registerPlaceHolderKeysArgsIsCalledOnAMap_whenQuery_thenShouldMatchCriteria() {
        // given
        Map<String, Object> map = new HashMap<>();
        // when
        ArgsRegistry.registerCustomTextPlaceHolderKeysArgs(map);
        // then
        assertAllSupportedCustomTextPlaceHolderKeysArePresent(map);
    }

    @Ignore
    @Test
    public void duplicate_given$registerPlaceHolderKeysArgsIsCalledOnAMap_whenQuery_thenShouldMatchCriteria() {
        // given
        Map<String, Object> map = new HashMap<>();
        // when
        ArgsRegistry.registerCustomTextPlaceHolderKeysArgs(map);
        // then
        assertAllSupportedCustomTextPlaceHolderKeysArePresent(map, getAllCustomTextPlaceHolderKeys());
    }

    private void assertAllInvocationEventsArePresent(Map<String, Object> map) {
        Assert.assertTrue(map.containsValue(InstabugInvocationEvent.NONE));
        Assert.assertTrue(map.containsValue(InstabugInvocationEvent.SHAKE));
        Assert.assertTrue(map.containsValue(InstabugInvocationEvent.FLOATING_BUTTON));
        Assert.assertTrue(map.containsValue(InstabugInvocationEvent.SCREENSHOT));
        Assert.assertTrue(map.containsValue(InstabugInvocationEvent.TWO_FINGER_SWIPE_LEFT));
    }

    private void assertAllWelcomeMessageStatesArePresent(Map<String, Object> map) {
        Assert.assertTrue(map.containsValue(WelcomeMessage.State.LIVE));
        Assert.assertTrue(map.containsValue(WelcomeMessage.State.BETA));
        Assert.assertTrue(map.containsValue(WelcomeMessage.State.DISABLED));
    }



    private void assertAllSupportedLocalesArePresent(Map<String, Object> map) {
        // source of truth
        List<Locale> expectedLocales = getCurrentlySupportLanguagesByTheSDK();
        // actual
        List<Locale> actualLocales = new ArrayList<>();
        for (Map.Entry m : map.entrySet()) {
            if (m.getValue() instanceof Locale) {
                actualLocales.add((Locale) m.getValue());
            }
        }
        StringBuilder stringBuilder = new StringBuilder();
        for (Locale expectedLocale : expectedLocales) {
            if (!actualLocales.contains(expectedLocale)) {
                stringBuilder.append(expectedLocale.getLanguage())
                        .append(" - ")
                        .append(expectedLocale.getCountry())
                        .append(" is missing")
                        .append("\n");
            }
        }
        String missingLangs = stringBuilder.toString();
        if (!missingLangs.isEmpty()) {
            Assert.fail(missingLangs);
        }
    }

    private void assertAllColorThemesArePresent(Map<String, Object> map) {
        Assert.assertTrue(map.containsValue(InstabugColorTheme.InstabugColorThemeDark));
        Assert.assertTrue(map.containsValue(InstabugColorTheme.InstabugColorThemeLight));
    }

    private void assertAllInvocationModesArePresent(Map<String, Object> map) {
        Assert.assertTrue(map.containsValue(BugReporting.ReportType.BUG));
        Assert.assertTrue(map.containsValue(BugReporting.ReportType.FEEDBACK));
    }

    private void assertAllInvocationOptionsArePresent(Map<String, Object> map) {
        Assert.assertTrue(map.containsValue(Option.COMMENT_FIELD_REQUIRED));
        Assert.assertTrue(map.containsValue(Option.DISABLE_POST_SENDING_DIALOG));
        Assert.assertTrue(map.containsValue(Option.EMAIL_FIELD_HIDDEN));
        Assert.assertTrue(map.containsValue(Option.EMAIL_FIELD_OPTIONAL));
    }

    private void assertAllSupportedCustomTextPlaceHolderKeysArePresent(Map<String, Object> map, List<InstabugCustomTextPlaceHolder.Key> expectedKeys) {
        // actual
        List<InstabugCustomTextPlaceHolder.Key> actualKeys = new ArrayList<>();
        for (Map.Entry m : map.entrySet()) {
            if (m.getValue() instanceof InstabugCustomTextPlaceHolder.Key) {
                actualKeys.add((InstabugCustomTextPlaceHolder.Key) m.getValue());
            }
        }
        StringBuilder stringBuilder = new StringBuilder();
        for (InstabugCustomTextPlaceHolder.Key expectedKey : expectedKeys) {
            if (!actualKeys.contains(expectedKey)) {
                stringBuilder.append(expectedKey)
                        .append(" is missing")
                        .append("\n");
            }
        }
        String missingKeys = stringBuilder.toString();
        if (!missingKeys.isEmpty()) {
            Assert.fail(missingKeys);
        }
    }

    private void assertAllSupportedCustomTextPlaceHolderKeysArePresent(Map<String, Object> map) {
        // source of truth
        List<InstabugCustomTextPlaceHolder.Key> expectedKeys = getCurrentlySupportedKeysBySDK();
        assertAllSupportedCustomTextPlaceHolderKeysArePresent(map, expectedKeys);
    }

    private List<Locale> getCurrentlySupportLanguagesByTheSDK() {
        List<Locale> langs = new ArrayList<>();
        langs.add(new Locale("en", ""));
        langs.add(new Locale("ar", ""));
        langs.add(new Locale("de", ""));
        langs.add(new Locale("es", ""));
        langs.add(new Locale("fr", ""));
        langs.add(new Locale("it", ""));
        langs.add(new Locale("ja", ""));
        langs.add(new Locale("ko", ""));
        langs.add(new Locale("pl", ""));
        langs.add(new Locale("pt", "BR"));
        langs.add(new Locale("pt", "PT"));
        langs.add(new Locale("ru", ""));
        langs.add(new Locale("sv", ""));
        langs.add(new Locale("tr", ""));
        langs.add(new Locale("zh", "CN"));
        langs.add(new Locale("zh", "TW"));
        langs.add(new Locale("cs", ""));
        langs.add(new Locale("in", ""));
        langs.add(new Locale("da", ""));
        langs.add(new Locale("sk", ""));
        langs.add(new Locale("nl", ""));
        langs.add(new Locale("no", ""));
        return langs;
    }

    private List<InstabugCustomTextPlaceHolder.Key> getCurrentlySupportedKeysBySDK() {
        List<InstabugCustomTextPlaceHolder.Key> keys = new ArrayList<>();
        keys.add(InstabugCustomTextPlaceHolder.Key.SHAKE_HINT);
        keys.add(InstabugCustomTextPlaceHolder.Key.SWIPE_HINT);
        keys.add(InstabugCustomTextPlaceHolder.Key.INVALID_EMAIL_MESSAGE);
        keys.add(InstabugCustomTextPlaceHolder.Key.INVALID_COMMENT_MESSAGE);
        keys.add(InstabugCustomTextPlaceHolder.Key.INVOCATION_HEADER);
        keys.add(InstabugCustomTextPlaceHolder.Key.START_CHATS);
        keys.add(InstabugCustomTextPlaceHolder.Key.REPORT_QUESTION);
        keys.add(InstabugCustomTextPlaceHolder.Key.REPORT_BUG);
        keys.add(InstabugCustomTextPlaceHolder.Key.REPORT_FEEDBACK);
        keys.add(InstabugCustomTextPlaceHolder.Key.EMAIL_FIELD_HINT);
        keys.add(InstabugCustomTextPlaceHolder.Key.COMMENT_FIELD_HINT_FOR_BUG_REPORT);
        keys.add(InstabugCustomTextPlaceHolder.Key.COMMENT_FIELD_HINT_FOR_FEEDBACK);
        keys.add(InstabugCustomTextPlaceHolder.Key.ADD_VOICE_MESSAGE);
        keys.add(InstabugCustomTextPlaceHolder.Key.ADD_IMAGE_FROM_GALLERY);
        keys.add(InstabugCustomTextPlaceHolder.Key.ADD_EXTRA_SCREENSHOT);
        keys.add(InstabugCustomTextPlaceHolder.Key.CONVERSATIONS_LIST_TITLE);
        keys.add(InstabugCustomTextPlaceHolder.Key.AUDIO_RECORDING_PERMISSION_DENIED);
        keys.add(InstabugCustomTextPlaceHolder.Key.CONVERSATION_TEXT_FIELD_HINT);
        keys.add(InstabugCustomTextPlaceHolder.Key.BUG_REPORT_HEADER);
        keys.add(InstabugCustomTextPlaceHolder.Key.FEEDBACK_REPORT_HEADER);
        keys.add(InstabugCustomTextPlaceHolder.Key.VOICE_MESSAGE_PRESS_AND_HOLD_TO_RECORD);
        keys.add(InstabugCustomTextPlaceHolder.Key.VOICE_MESSAGE_RELEASE_TO_ATTACH);
        keys.add(InstabugCustomTextPlaceHolder.Key.REPORT_SUCCESSFULLY_SENT);
        keys.add(InstabugCustomTextPlaceHolder.Key.SUCCESS_DIALOG_HEADER);
        keys.add(InstabugCustomTextPlaceHolder.Key.ADD_VIDEO);
        keys.add(InstabugCustomTextPlaceHolder.Key.BETA_WELCOME_MESSAGE_WELCOME_STEP_TITLE);
        keys.add(InstabugCustomTextPlaceHolder.Key.BETA_WELCOME_MESSAGE_WELCOME_STEP_CONTENT);
        keys.add(InstabugCustomTextPlaceHolder.Key.BETA_WELCOME_MESSAGE_HOW_TO_REPORT_STEP_TITLE);
        keys.add(InstabugCustomTextPlaceHolder.Key.BETA_WELCOME_MESSAGE_HOW_TO_REPORT_STEP_CONTENT);
        keys.add(InstabugCustomTextPlaceHolder.Key.BETA_WELCOME_MESSAGE_FINISH_STEP_TITLE);
        keys.add(InstabugCustomTextPlaceHolder.Key.BETA_WELCOME_MESSAGE_FINISH_STEP_CONTENT);
        keys.add(InstabugCustomTextPlaceHolder.Key.LIVE_WELCOME_MESSAGE_TITLE);
        keys.add(InstabugCustomTextPlaceHolder.Key.LIVE_WELCOME_MESSAGE_CONTENT);
        return keys;
    }

    private List<InstabugCustomTextPlaceHolder.Key> getAllCustomTextPlaceHolderKeys() {
        List<InstabugCustomTextPlaceHolder.Key> keys = new ArrayList<>();
        keys.add(InstabugCustomTextPlaceHolder.Key.SHAKE_HINT);
        keys.add(InstabugCustomTextPlaceHolder.Key.SWIPE_HINT);
        keys.add(InstabugCustomTextPlaceHolder.Key.INVALID_EMAIL_MESSAGE);
        keys.add(InstabugCustomTextPlaceHolder.Key.INVALID_COMMENT_MESSAGE);
        keys.add(InstabugCustomTextPlaceHolder.Key.INVOCATION_HEADER);
        keys.add(InstabugCustomTextPlaceHolder.Key.START_CHATS);
        keys.add(InstabugCustomTextPlaceHolder.Key.REPORT_QUESTION);
        keys.add(InstabugCustomTextPlaceHolder.Key.REPORT_BUG);
        keys.add(InstabugCustomTextPlaceHolder.Key.REPORT_FEEDBACK);
        keys.add(InstabugCustomTextPlaceHolder.Key.EMAIL_FIELD_HINT);
        keys.add(InstabugCustomTextPlaceHolder.Key.COMMENT_FIELD_HINT_FOR_BUG_REPORT);
        keys.add(InstabugCustomTextPlaceHolder.Key.COMMENT_FIELD_HINT_FOR_FEEDBACK);
        keys.add(InstabugCustomTextPlaceHolder.Key.ADD_VOICE_MESSAGE);
        keys.add(InstabugCustomTextPlaceHolder.Key.ADD_IMAGE_FROM_GALLERY);
        keys.add(InstabugCustomTextPlaceHolder.Key.ADD_EXTRA_SCREENSHOT);
        keys.add(InstabugCustomTextPlaceHolder.Key.CONVERSATIONS_LIST_TITLE);
        keys.add(InstabugCustomTextPlaceHolder.Key.AUDIO_RECORDING_PERMISSION_DENIED);
        keys.add(InstabugCustomTextPlaceHolder.Key.CONVERSATION_TEXT_FIELD_HINT);
        keys.add(InstabugCustomTextPlaceHolder.Key.BUG_REPORT_HEADER);
        keys.add(InstabugCustomTextPlaceHolder.Key.FEEDBACK_REPORT_HEADER);
        keys.add(InstabugCustomTextPlaceHolder.Key.VOICE_MESSAGE_PRESS_AND_HOLD_TO_RECORD);
        keys.add(InstabugCustomTextPlaceHolder.Key.VOICE_MESSAGE_RELEASE_TO_ATTACH);
        keys.add(InstabugCustomTextPlaceHolder.Key.REPORT_SUCCESSFULLY_SENT);
        keys.add(InstabugCustomTextPlaceHolder.Key.SUCCESS_DIALOG_HEADER);
        keys.add(InstabugCustomTextPlaceHolder.Key.ADD_VIDEO);
        keys.add(InstabugCustomTextPlaceHolder.Key.BETA_WELCOME_MESSAGE_WELCOME_STEP_TITLE);
        keys.add(InstabugCustomTextPlaceHolder.Key.BETA_WELCOME_MESSAGE_WELCOME_STEP_CONTENT);
        keys.add(InstabugCustomTextPlaceHolder.Key.BETA_WELCOME_MESSAGE_HOW_TO_REPORT_STEP_TITLE);
        keys.add(InstabugCustomTextPlaceHolder.Key.BETA_WELCOME_MESSAGE_HOW_TO_REPORT_STEP_CONTENT);
        keys.add(InstabugCustomTextPlaceHolder.Key.BETA_WELCOME_MESSAGE_FINISH_STEP_TITLE);
        keys.add(InstabugCustomTextPlaceHolder.Key.BETA_WELCOME_MESSAGE_FINISH_STEP_CONTENT);
        keys.add(InstabugCustomTextPlaceHolder.Key.LIVE_WELCOME_MESSAGE_TITLE);
        keys.add(InstabugCustomTextPlaceHolder.Key.LIVE_WELCOME_MESSAGE_CONTENT);
        keys.add(InstabugCustomTextPlaceHolder.Key.VIDEO_PLAYER_TITLE);
        keys.add(InstabugCustomTextPlaceHolder.Key.FEATURES_REQUEST);
        keys.add(InstabugCustomTextPlaceHolder.Key.FEATURES_REQUEST_ADD_FEATURE_TOAST);
        keys.add(InstabugCustomTextPlaceHolder.Key.FEATURES_REQUEST_ADD_FEATURE_THANKS_MESSAGE);
        keys.add(InstabugCustomTextPlaceHolder.Key.SURVEYS_WELCOME_SCREEN_TITLE);
        keys.add(InstabugCustomTextPlaceHolder.Key.SURVEYS_WELCOME_SCREEN_SUBTITLE);
        keys.add(InstabugCustomTextPlaceHolder.Key.SURVEYS_WELCOME_SCREEN_BUTTON);
        keys.add(InstabugCustomTextPlaceHolder.Key.REQUEST_FEATURE);
        return keys;
    }
}
