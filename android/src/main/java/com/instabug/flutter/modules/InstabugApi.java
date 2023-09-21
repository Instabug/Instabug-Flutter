package com.instabug.flutter.modules;

import android.app.Application;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.VisibleForTesting;

import com.instabug.flutter.util.ArgsRegistry;
import com.instabug.flutter.generated.InstabugPigeon;
import com.instabug.flutter.util.Reflection;
import com.instabug.flutter.util.ThreadManager;
import com.instabug.library.Feature;
import com.instabug.library.Instabug;
import com.instabug.library.InstabugColorTheme;
import com.instabug.library.InstabugCustomTextPlaceHolder;
import com.instabug.library.IssueType;
import com.instabug.library.Platform;
import com.instabug.library.ReproConfigurations;
import com.instabug.library.internal.module.InstabugLocale;
import com.instabug.library.invocation.InstabugInvocationEvent;
import com.instabug.library.model.NetworkLog;
import com.instabug.library.ui.onboarding.WelcomeMessage;

import org.json.JSONObject;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.concurrent.Callable;

import io.flutter.FlutterInjector;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.embedding.engine.loader.FlutterLoader;

public class InstabugApi implements InstabugPigeon.InstabugHostApi {
    private final String TAG = InstabugApi.class.getName();
    private final Context context;
    private final Callable<Bitmap> screenshotProvider;
    private final InstabugCustomTextPlaceHolder placeHolder = new InstabugCustomTextPlaceHolder();

    public static void init(BinaryMessenger messenger, Context context, Callable<Bitmap> screenshotProvider) {
        final InstabugApi api = new InstabugApi(context, screenshotProvider);
        InstabugPigeon.InstabugHostApi.setup(messenger, api);
    }

    public InstabugApi(Context context, Callable<Bitmap> screenshotProvider) {
        this.context = context;
        this.screenshotProvider = screenshotProvider;
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
            if(isEnabled)
                Instabug.enable();
            else
                Instabug.disable();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void init(@NonNull String token, @NonNull List<String> invocationEvents, @NonNull String debugLogsLevel) {
        setCurrentPlatform();

        InstabugInvocationEvent[] invocationEventsArray = new InstabugInvocationEvent[invocationEvents.size()];
        for (int i = 0; i < invocationEvents.size(); i++) {
            String key = invocationEvents.get(i);
            invocationEventsArray[i] = ArgsRegistry.invocationEvents.get(key);
        }

        final Application application = (Application) context;
        final int parsedLogLevel = ArgsRegistry.sdkLogLevels.get(debugLogsLevel);

        new Instabug.Builder(application, token)
                .setInvocationEvents(invocationEventsArray)
                .setSdkDebugLogsLevel(parsedLogLevel)
                .build();

        Instabug.setScreenshotProvider(screenshotProvider);
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
    public void identifyUser(@NonNull String email, @Nullable String name) {
        Instabug.identifyUser(name, email);
    }

    @Override
    public void setUserData(@NonNull String data) {
        Instabug.setUserData(data);
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
    public void setPrimaryColor(@NonNull Long color) {
        Instabug.setPrimaryColor(color.intValue());
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
        if(ArgsRegistry.placeholders.containsKey(key)) {
            InstabugCustomTextPlaceHolder.Key resolvedKey = ArgsRegistry.placeholders.get(key);
            placeHolder.set(resolvedKey, value);
            Instabug.setCustomTextPlaceHolders(placeHolder);
        }
        else {
            Log.i(TAG, "Instabug: " + key +  " is only relevant to iOS.");
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
    public void addExperiments(@NonNull List<String> experiments) {
        Instabug.addExperiments(experiments);
    }

    @Override
    public void removeExperiments(@NonNull List<String> experiments) {
        Instabug.removeExperiments(experiments);
    }

    @Override
    public void clearAllExperiments() {
        Instabug.clearAllExperiments();
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
    public void setReproStepsConfig(@Nullable String bugMode, @Nullable String crashMode) {
        try {
            final ReproConfigurations.Builder builder = new ReproConfigurations.Builder();

            if (bugMode != null) {
                final Integer resolvedBugMode = ArgsRegistry.reproModes.get(bugMode);
                builder.setIssueMode(IssueType.Bug, resolvedBugMode);
            }

            if (crashMode != null) {
                final Integer resolvedCrashMode = ArgsRegistry.reproModes.get(crashMode);
                builder.setIssueMode(IssueType.Crash, resolvedCrashMode);
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
}
