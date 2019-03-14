package com.instabug.instabugflutter;

import com.instabug.bug.BugReporting;
import com.instabug.bug.invocation.Option;
import com.instabug.library.InstabugColorTheme;
import com.instabug.library.invocation.InstabugInvocationEvent;
import com.instabug.library.ui.onboarding.WelcomeMessage;

import org.junit.Assert;
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
        Locale actualLocale = ArgsRegistry.getDeserializedValue("Locale.English", Locale.class);
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
}
