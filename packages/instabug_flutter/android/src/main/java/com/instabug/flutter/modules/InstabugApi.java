package com.instabug.flutter.modules;

import android.app.Application;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.graphics.Typeface;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.VisibleForTesting;

import com.instabug.flutter.generated.InstabugPigeon;
import com.instabug.flutter.util.ArgsRegistry;
import com.instabug.flutter.util.Reflection;
import com.instabug.flutter.util.ThreadManager;
import com.instabug.library.ReproMode;
import com.instabug.library.internal.crossplatform.CoreFeature;
import com.instabug.library.internal.crossplatform.CoreFeaturesState;
import com.instabug.library.internal.crossplatform.FeaturesStateListener;
import com.instabug.library.internal.crossplatform.InternalCore;
import com.instabug.flutter.util.privateViews.ScreenshotCaptor;
import com.instabug.library.Feature;
import com.instabug.library.Instabug;
import com.instabug.library.InstabugColorTheme;
import com.instabug.library.InstabugCustomTextPlaceHolder;
import com.instabug.library.IssueType;
import com.instabug.library.Platform;
import com.instabug.library.ReproConfigurations;
import com.instabug.library.featuresflags.model.IBGFeatureFlag;
import com.instabug.library.internal.crossplatform.InternalCore;
import com.instabug.library.internal.module.InstabugLocale;
import com.instabug.library.invocation.InstabugInvocationEvent;
import com.instabug.library.model.NetworkLog;
import com.instabug.library.screenshot.instacapture.ScreenshotRequest;
import com.instabug.library.ui.onboarding.WelcomeMessage;

import io.flutter.FlutterInjector;
import io.flutter.embedding.engine.loader.FlutterLoader;
import io.flutter.plugin.common.BinaryMessenger;

import org.jetbrains.annotations.NotNull;
import org.json.JSONObject;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.concurrent.Callable;

public class InstabugApi implements InstabugPigeon.InstabugHostApi {
    private final String TAG = InstabugApi.class.getName();
    private final Context context;
    private final Callable<Bitmap> screenshotProvider;
    private final InstabugCustomTextPlaceHolder placeHolder = new InstabugCustomTextPlaceHolder();

    private final InstabugPigeon.FeatureFlagsFlutterApi featureFlagsFlutterApi;

    public static void init(BinaryMessenger messenger, Context context, Callable<Bitmap> screenshotProvider) {
        final InstabugPigeon.FeatureFlagsFlutterApi flutterApi = new InstabugPigeon.FeatureFlagsFlutterApi(messenger);

        final InstabugApi api = new InstabugApi(context, screenshotProvider, flutterApi);
        InstabugPigeon.InstabugHostApi.setup(messenger, api);
    }

    public InstabugApi(Context context, Callable<Bitmap> screenshotProvider, InstabugPigeon.FeatureFlagsFlutterApi featureFlagsFlutterApi) {
        this.context = context;
        this.screenshotProvider = screenshotProvider;
        this.featureFlagsFlutterApi = featureFlagsFlutterApi;
    }

    @VisibleForTesting
    public void setCurrentPlatform() {
        try {
            Method method = Reflection.getMethod(Class.forName("com.instabug.library.Instabug"), "setCurrentPlatform", int.class);
            if (method != null) {
                method.invoke(null, Platform.FLUTTER);
            } else {
                Log.e(TAG, "setCurrentPlatform was not found by reflection");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void setEnabled(@NonNull Boolean isEnabled) {
        try {
            if (isEnabled)
                Instabug.enable();
            else
                Instabug.disable();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @NotNull
    @Override
    public Boolean isEnabled() {
        return Instabug.isEnabled();
    }

    @NotNull
    @Override
    public Boolean isBuilt() {
        return Instabug.isBuilt();
    }

    @Override
    public void init(@NonNull String token, @NonNull List<String> invocationEvents, @NonNull String debugLogsLevel, @Nullable String appVariant) {
        setCurrentPlatform();

        InstabugInvocationEvent[] invocationEventsArray = new InstabugInvocationEvent[invocationEvents.size()];
        for (int i = 0; i < invocationEvents.size(); i++) {
            String key = invocationEvents.get(i);
            invocationEventsArray[i] = ArgsRegistry.invocationEvents.get(key);
        }

        final Application application = (Application) context;
        final int parsedLogLevel = ArgsRegistry.sdkLogLevels.get(debugLogsLevel);
        Instabug.Builder builder = new Instabug.Builder(application, token)
                .setInvocationEvents(invocationEventsArray)
                .setSdkDebugLogsLevel(parsedLogLevel);
        if (appVariant != null) {
            builder.setAppVariant(appVariant);
        }

        builder.build();

        Instabug.setScreenshotProvider(screenshotProvider);
        try {
            Class<?> myClass = Class.forName("com.instabug.library.Instabug");
            // Enable/Disable native user steps capturing
            Method method = myClass.getDeclaredMethod("shouldDisableNativeUserStepsCapturing", boolean.class);
            method.setAccessible(true);
            method.invoke(null, true);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void enableAutoMasking(@NonNull List<String> autoMasking) {
        int[] autoMaskingArray = new int[autoMasking.size()];
        for (int i = 0; i < autoMasking.size(); i++) {
            String key = autoMasking.get(i);
            autoMaskingArray[i] = ArgsRegistry.autoMasking.get(key);
        }

        Instabug.setAutoMaskScreenshotsTypes(Arrays.copyOf(autoMaskingArray, autoMaskingArray.length));
    }

    @Override
    public void show() {
        Instabug.show();
    }

    @Override
    public void showWelcomeMessageWithMode(@NonNull String mode) {
        WelcomeMessage.State resolvedMode = ArgsRegistry.welcomeMessageStates.get(mode);
        Instabug.showWelcomeMessage(resolvedMode);
    }

    @Override
    public void identifyUser(@NonNull String email, @Nullable String name, @Nullable String userId) {
        Instabug.identifyUser(name, email, userId);
    }

    @Override
    public void setUserData(@NonNull String data) {
        Instabug.setUserData(data);
    }

    @Override
    public void setAppVariant(@NonNull String appVariant) {
        try {
            Instabug.setAppVariant(appVariant);

        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    @Override
    public void logUserEvent(@NonNull String name) {
        Instabug.logUserEvent(name);
    }

    @Override
    public void logOut() {
        Instabug.logoutUser();
    }

    @Override
    public void setEnableUserSteps(@NonNull Boolean isEnabled) {
        Instabug.setTrackingUserStepsState(isEnabled ? Feature.State.ENABLED : Feature.State.DISABLED);
    }

    @Override

    public void logUserSteps(@NonNull String gestureType, @NonNull String message, @Nullable String viewName) {
        try {
            final String stepType = ArgsRegistry.gestureStepType.get(gestureType);
            final long timeStamp = System.currentTimeMillis();
            String view = "";

            Method method = Reflection.getMethod(Class.forName("com.instabug.library.Instabug"), "addUserStep",
                    long.class, String.class, String.class, String.class, String.class);
            if (method != null) {
                if (viewName != null) {
                    view = viewName;
                }

                method.invoke(null, timeStamp, stepType, message, null, view);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void setLocale(@NonNull String locale) {
        final InstabugLocale resolvedLocale = ArgsRegistry.locales.get(locale);
        Instabug.setLocale(new Locale(resolvedLocale.getCode(), resolvedLocale.getCountry()));
    }

    @Override
    public void setColorTheme(@NonNull String theme) {
        InstabugColorTheme resolvedTheme = ArgsRegistry.colorThemes.get(theme);
        Instabug.setColorTheme(resolvedTheme);
    }

    @Override
    public void setWelcomeMessageMode(@NonNull String mode) {
        WelcomeMessage.State resolvedMode = ArgsRegistry.welcomeMessageStates.get(mode);
        Instabug.setWelcomeMessageState(resolvedMode);
    }


    @Override
    public void setSessionProfilerEnabled(@NonNull Boolean enabled) {
        if (enabled) {
            Instabug.setSessionProfilerState(Feature.State.ENABLED);
        } else {
            Instabug.setSessionProfilerState(Feature.State.DISABLED);
        }
    }

    @Override
    public void setValueForStringWithKey(@NonNull String value, @NonNull String key) {
        if (ArgsRegistry.placeholders.containsKey(key)) {
            InstabugCustomTextPlaceHolder.Key resolvedKey = ArgsRegistry.placeholders.get(key);
            placeHolder.set(resolvedKey, value);
            Instabug.setCustomTextPlaceHolders(placeHolder);
        } else {
            Log.i(TAG, "Instabug: " + key + " is only relevant to iOS.");
        }
    }

    @Override
    public void appendTags(@NonNull List<String> tags) {
        Instabug.addTags(tags.toArray(new String[0]));
    }

    @Override
    public void resetTags() {
        Instabug.resetTags();
    }

    @Override
    public void getTags(InstabugPigeon.Result<List<String>> result) {
        ThreadManager.runOnBackground(
                new Runnable() {
                    @Override
                    public void run() {
                        final List<String> tags = Instabug.getTags();

                        ThreadManager.runOnMainThread(new Runnable() {
                            @Override
                            public void run() {
                                result.success(tags);
                            }
                        });
                    }
                }
        );
    }



    @Override
    public void addFeatureFlags(@NonNull Map<String, String> featureFlags) {
        try {
            List<IBGFeatureFlag> features = new ArrayList<>();
            for (Map.Entry<String, String> entry : featureFlags.entrySet()) {
                features.add(new IBGFeatureFlag(entry.getKey(), entry.getValue().isEmpty() ? null : entry.getValue()));
            }
            Instabug.addFeatureFlags(features);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void removeFeatureFlags(@NonNull List<String> featureFlags) {
        try {
            Instabug.removeFeatureFlag(featureFlags);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void removeAllFeatureFlags() {
        try {
            Instabug.removeAllFeatureFlags();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void setUserAttribute(@NonNull String value, @NonNull String key) {
        Instabug.setUserAttribute(key, value);
    }

    @Override
    public void removeUserAttribute(@NonNull String key) {
        Instabug.removeUserAttribute(key);
    }


    @Override
    public void getUserAttributeForKey(@NonNull String key, InstabugPigeon.Result<String> result) {
        ThreadManager.runOnBackground(
                new Runnable() {
                    @Override
                    public void run() {
                        final String attribute = Instabug.getUserAttribute(key);

                        ThreadManager.runOnMainThread(new Runnable() {
                            @Override
                            public void run() {
                                result.success(attribute);
                            }
                        });
                    }
                }
        );
    }

    @Override
    public void getUserAttributes(InstabugPigeon.Result<Map<String, String>> result) {
        ThreadManager.runOnBackground(
                new Runnable() {
                    @Override
                    public void run() {
                        final Map<String, String> attributes = Instabug.getAllUserAttributes();

                        ThreadManager.runOnMainThread(new Runnable() {
                            @Override
                            public void run() {
                                result.success(attributes);
                            }
                        });
                    }
                }
        );
    }

    @Override
    public void setReproStepsConfig(@Nullable String bugMode, @Nullable String crashMode, @Nullable String sessionReplayMode) {
        try {
            final ReproConfigurations.Builder builder = new ReproConfigurations.Builder();

            if (bugMode != null) {
                final Integer resolvedBugMode = ArgsRegistry.reproModes.get(bugMode);
                builder.setIssueMode(IssueType.Bug, resolvedBugMode);
            }

            if (crashMode != null) {
                final Integer resolvedCrashMode = ArgsRegistry.reproModes.get(crashMode);
                builder.setIssueMode(IssueType.AllCrashes, resolvedCrashMode);
            }

            if (sessionReplayMode != null) {
                final Integer resolvedSessionReplayMode = ArgsRegistry.reproModes.get(sessionReplayMode);
                builder.setIssueMode(IssueType.SessionReplay, resolvedSessionReplayMode);
            }

            final ReproConfigurations config = builder.build();

            Instabug.setReproConfigurations(config);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void reportScreenChange(@NonNull String screenName) {
        try {
            Method method = Reflection.getMethod(Class.forName("com.instabug.library.Instabug"), "reportScreenChange",
                    Bitmap.class, String.class);
            if (method != null) {
                method.invoke(null, null, screenName);
            }
            Method reportView = Reflection.getMethod(Class.forName("com.instabug.library.Instabug"), "reportCurrentViewChange",
                    String.class);

            if (reportView != null) {
                reportView.invoke(null, screenName);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @VisibleForTesting
    public Bitmap getBitmapForAsset(String assetName) {
        try {
            FlutterLoader loader = FlutterInjector.instance().flutterLoader();
            String key = loader.getLookupKeyForAsset(assetName);
            InputStream stream = context.getAssets().open(key);
            return BitmapFactory.decodeStream(stream);
        } catch (IOException exception) {
            return null;
        }
    }

    @Override
    public void setCustomBrandingImage(@NonNull String light, @NonNull String dark) {
        try {
            Bitmap lightLogoVariant = getBitmapForAsset(light);
            Bitmap darkLogoVariant = getBitmapForAsset(dark);

            if (lightLogoVariant == null) {
                lightLogoVariant = darkLogoVariant;
            }
            if (darkLogoVariant == null) {
                darkLogoVariant = lightLogoVariant;
            }
            if (lightLogoVariant == null) {
                throw new Exception("Couldn't find the light or dark logo images");
            }

            Method method = Reflection.getMethod(Class.forName("com.instabug.library.Instabug"), "setCustomBrandingImage", Bitmap.class, Bitmap.class);

            if (method != null) {
                method.invoke(null, lightLogoVariant, darkLogoVariant);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void setFont(@NonNull String font) {
        // iOS Only
    }

    @Override
    public void addFileAttachmentWithURL(@NonNull String filePath, @NonNull String fileName) {
        final File file = new File(filePath);
        if (file.exists()) {
            Instabug.addFileAttachment(Uri.fromFile(file), fileName);
        }
    }

    @Override
    public void addFileAttachmentWithData(@NonNull byte[] data, @NonNull String fileName) {
        Instabug.addFileAttachment(data, fileName);
    }

    @Override
    public void clearFileAttachments() {
        Instabug.clearFileAttachment();
    }

    @Override
    public void networkLog(@NonNull Map<String, Object> data) {
        try {
            NetworkLog networkLog = new NetworkLog();
            String date = System.currentTimeMillis() + "";

            networkLog.setDate(date);
            networkLog.setUrl((String) data.get("url"));
            networkLog.setRequest((String) data.get("requestBody"));
            networkLog.setResponse((String) data.get("responseBody"));
            networkLog.setMethod((String) data.get("method"));
            networkLog.setResponseCode((Integer) data.get("responseCode"));
            networkLog.setRequestHeaders((new JSONObject((HashMap<String, String>) data.get("requestHeaders"))).toString(4));
            networkLog.setResponseHeaders((new JSONObject((HashMap<String, String>) data.get("responseHeaders"))).toString(4));
            networkLog.setTotalDuration(((Number) data.get("duration")).longValue() / 1000);

            networkLog.insert();
        } catch (Exception e) {
            Log.e(TAG, "Network logging failed");
        }
    }

    @Override
    public void registerFeatureFlagChangeListener() {

        try {
            InternalCore.INSTANCE._setFeaturesStateListener(new FeaturesStateListener() {
                @Override
                public void invoke(@NonNull CoreFeaturesState featuresState) {
                    ThreadManager.runOnMainThread(new Runnable() {
                        @Override
                        public void run() {
                            featureFlagsFlutterApi.onW3CFeatureFlagChange(featuresState.isW3CExternalTraceIdEnabled(),
                                    featuresState.isAttachingGeneratedHeaderEnabled(),
                                    featuresState.isAttachingCapturedHeaderEnabled(),
                                    new InstabugPigeon.FeatureFlagsFlutterApi.Reply<Void>() {
                                        @Override
                                        public void reply(Void reply) {

                                        }
                                    });

                            featureFlagsFlutterApi.onNetworkLogBodyMaxSizeChange(
                                    (long) featuresState.getNetworkLogCharLimit(),
                                    reply -> {}
                            );
                        }
                    });
                }

            });
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    @NonNull
    @Override
    public Map<String, Boolean> isW3CFeatureFlagsEnabled() {
        Map<String, Boolean> params = new HashMap<String, Boolean>();
        params.put("isW3cExternalTraceIDEnabled", InternalCore.INSTANCE._isFeatureEnabled(CoreFeature.W3C_EXTERNAL_TRACE_ID));
        params.put("isW3cExternalGeneratedHeaderEnabled", InternalCore.INSTANCE._isFeatureEnabled(CoreFeature.W3C_ATTACHING_GENERATED_HEADER));
        params.put("isW3cCaughtHeaderEnabled", InternalCore.INSTANCE._isFeatureEnabled(CoreFeature.W3C_ATTACHING_CAPTURED_HEADER));


        return params;
    }

    @Override
    public void willRedirectToStore() {
        Instabug.willRedirectToStore();
    }

    public static void setScreenshotCaptor(ScreenshotCaptor screenshotCaptor, InternalCore internalCore) {
        internalCore._setScreenshotCaptor(new com.instabug.library.screenshot.ScreenshotCaptor() {
            @Override
            public void capture(@NonNull ScreenshotRequest screenshotRequest) {
                screenshotCaptor.capture(new ScreenshotCaptor.CapturingCallback() {
                    @Override
                    public void onCapturingFailure(Throwable throwable) {
                        screenshotRequest.getListener().onCapturingFailure(throwable);
                    }

                    @Override
                    public void onCapturingSuccess(Bitmap bitmap) {
                        screenshotRequest.getListener().onCapturingSuccess(bitmap);
                    }
                });
            }
        });
    }

    @Override
    public void setNetworkLogBodyEnabled(@NonNull Boolean isEnabled) {
        try {
            Instabug.setNetworkLogBodyEnabled(isEnabled);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void setTheme(@NonNull Map<String, Object> themeConfig) {
        try {
            Log.d(TAG, "setTheme called with config: " + themeConfig.toString());

            com.instabug.library.model.IBGTheme.Builder builder = new com.instabug.library.model.IBGTheme.Builder();

            if (themeConfig.containsKey("primaryColor")) {
                builder.setPrimaryColor(getColor(themeConfig, "primaryColor"));
            }
            if (themeConfig.containsKey("secondaryTextColor")) {
                builder.setSecondaryTextColor(getColor(themeConfig, "secondaryTextColor"));
            }
            if (themeConfig.containsKey("primaryTextColor")) {
                builder.setPrimaryTextColor(getColor(themeConfig, "primaryTextColor"));
            }
            if (themeConfig.containsKey("titleTextColor")) {
                builder.setTitleTextColor(getColor(themeConfig, "titleTextColor"));
            }
            if (themeConfig.containsKey("backgroundColor")) {
                builder.setBackgroundColor(getColor(themeConfig, "backgroundColor"));
            }

            if (themeConfig.containsKey("primaryTextStyle")) {
                builder.setPrimaryTextStyle(getTextStyle(themeConfig, "primaryTextStyle"));
            }
            if (themeConfig.containsKey("secondaryTextStyle")) {
                builder.setSecondaryTextStyle(getTextStyle(themeConfig, "secondaryTextStyle"));
            }
            if (themeConfig.containsKey("ctaTextStyle")) {
                builder.setCtaTextStyle(getTextStyle(themeConfig, "ctaTextStyle"));
            }

            setFontIfPresent(themeConfig, builder, "primaryFontPath", "primaryFontAsset", "primary");
            setFontIfPresent(themeConfig, builder, "secondaryFontPath", "secondaryFontAsset", "secondary");
            setFontIfPresent(themeConfig, builder, "ctaFontPath", "ctaFontAsset", "CTA");

            com.instabug.library.model.IBGTheme theme = builder.build();
            Instabug.setTheme(theme);
            Log.d(TAG, "Theme applied successfully");

        } catch (Exception e) {
            Log.e(TAG, "Error in setTheme: " + e.getMessage());
            e.printStackTrace();
        }
    }



    /**
     * Retrieves a color value from the Map.
     *
     * @param map The Map object.
     * @param key The key to look for.
     * @return The parsed color as an integer, or black if missing or invalid.
     */
    private int getColor(Map<String, Object> map, String key) {
        try {
            if (map != null && map.containsKey(key) && map.get(key) != null) {
                String colorString = (String) map.get(key);
                return android.graphics.Color.parseColor(colorString);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return android.graphics.Color.BLACK;
    }

    /**
     * Retrieves a text style from the Map.
     *
     * @param map The Map object.
     * @param key The key to look for.
     * @return The corresponding Typeface style, or Typeface.NORMAL if missing or invalid.
     */
    private int getTextStyle(Map<String, Object> map, String key) {
        try {
            if (map != null && map.containsKey(key) && map.get(key) != null) {
                String style = (String) map.get(key);
                switch (style.toLowerCase()) {
                    case "bold":
                        return Typeface.BOLD;
                    case "italic":
                        return Typeface.ITALIC;
                    case "bold_italic":
                        return Typeface.BOLD_ITALIC;
                    case "normal":
                    default:
                        return Typeface.NORMAL;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return Typeface.NORMAL;
    }

    /**
     * Sets a font on the theme builder if the font configuration is present in the theme config.
     *
     * @param themeConfig The theme configuration map
     * @param builder The theme builder
     * @param fileKey The key for font file path
     * @param assetKey The key for font asset path
     * @param fontType The type of font (for logging purposes)
     */
    private void setFontIfPresent(Map<String, Object> themeConfig, com.instabug.library.model.IBGTheme.Builder builder,
                                 String fileKey, String assetKey, String fontType) {
        if (themeConfig.containsKey(fileKey) || themeConfig.containsKey(assetKey)) {
            Typeface typeface = getTypeface(themeConfig, fileKey, assetKey);
            if (typeface != null) {
                switch (fontType) {
                    case "primary":
                        builder.setPrimaryTextFont(typeface);
                        break;
                    case "secondary":
                        builder.setSecondaryTextFont(typeface);
                        break;
                    case "CTA":
                        builder.setCtaTextFont(typeface);
                        break;
                }
            }
        }
    }

    private Typeface getTypeface(Map<String, Object> map, String fileKey, String assetKey) {
        String fontName = null;

        if (assetKey != null && map.containsKey(assetKey) && map.get(assetKey) != null) {
            fontName = (String) map.get(assetKey);
        } else if (fileKey != null && map.containsKey(fileKey) && map.get(fileKey) != null) {
            fontName = (String) map.get(fileKey);
        }

        if (fontName == null) {
            return Typeface.DEFAULT;
        }

        try {
            String assetPath = "fonts/" + fontName;
            return Typeface.createFromAsset(context.getAssets(), assetPath);
        } catch (Exception e) {
            try {
                return Typeface.create(fontName, Typeface.NORMAL);
            } catch (Exception e2) {
                return Typeface.DEFAULT;
            }
        }
    }
    /**
     * Enables or disables displaying in full-screen mode, hiding the status and navigation bars.
     * @param isEnabled A boolean to enable/disable setFullscreen.
     */
    @Override
    public void setFullscreen(@NonNull final Boolean isEnabled) {
        try {
            Instabug.setFullscreen(isEnabled);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void getNetworkBodyMaxSize(@NonNull InstabugPigeon.Result<Double> result) {
        ThreadManager.runOnMainThread(
            new Runnable() {
                @Override
                public void run() {
                    try {
                        double networkCharLimit = InternalCore.INSTANCE.get_networkLogCharLimit();
                        result.success(networkCharLimit);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }
        );
    }
}
