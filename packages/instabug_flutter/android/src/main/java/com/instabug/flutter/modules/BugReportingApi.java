package com.instabug.flutter.modules;

import android.annotation.SuppressLint;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.instabug.bug.BugReporting;
import com.instabug.flutter.generated.BugReportingPigeon;
import com.instabug.flutter.util.ArgsRegistry;
import com.instabug.flutter.util.ThreadManager;
import com.instabug.library.Feature;
import com.instabug.library.OnSdkDismissCallback;
import com.instabug.library.extendedbugreport.ExtendedBugReport;
import com.instabug.library.invocation.InstabugInvocationEvent;
import com.instabug.library.invocation.OnInvokeCallback;
import com.instabug.library.invocation.util.InstabugFloatingButtonEdge;
import com.instabug.library.invocation.util.InstabugVideoRecordingButtonPosition;

import java.util.List;

import io.flutter.plugin.common.BinaryMessenger;

public class BugReportingApi implements BugReportingPigeon.BugReportingHostApi {
    private final BugReportingPigeon.BugReportingFlutterApi flutterApi;

    public static void init(BinaryMessenger messenger) {
        final BugReportingPigeon.BugReportingFlutterApi flutterApi = new BugReportingPigeon.BugReportingFlutterApi(messenger);
        final BugReportingApi api = new BugReportingApi(flutterApi);
        BugReportingPigeon.BugReportingHostApi.setup(messenger, api);
    }

    public BugReportingApi(BugReportingPigeon.BugReportingFlutterApi flutterApi) {
        this.flutterApi = flutterApi;
    }

    @Override
    public void setEnabled(@NonNull Boolean isEnabled) {
        if (isEnabled) {
            BugReporting.setState(Feature.State.ENABLED);
        } else {
            BugReporting.setState(Feature.State.DISABLED);
        }
    }

    @SuppressLint("WrongConstant")
    @Override
    public void show(@NonNull String reportType, @Nullable List<String> invocationOptions) {
        int[] options = new int[invocationOptions.size()];
        for (int i = 0; i < invocationOptions.size(); i++) {
            options[i] = ArgsRegistry.invocationOptions.get(invocationOptions.get(i));
        }
        int reportTypeInt = ArgsRegistry.reportTypes.get(reportType);
        BugReporting.show(reportTypeInt, options);
    }

    @Override
    public void setInvocationEvents(@NonNull List<String> events) {
        InstabugInvocationEvent[] invocationEventsArray = new InstabugInvocationEvent[events.size()];

        for (int i = 0; i < events.size(); i++) {
            String key = events.get(i);
            invocationEventsArray[i] = ArgsRegistry.invocationEvents.get(key);
        }

        BugReporting.setInvocationEvents(invocationEventsArray);
    }

    @SuppressLint("WrongConstant")
    @Override
    public void setReportTypes(@NonNull List<String> types) {
        int[] reportTypesArray = new int[types.size()];

        for (int i = 0; i < types.size(); i++) {
            String key = types.get(i);
            reportTypesArray[i] = ArgsRegistry.reportTypes.get(key);
        }

        BugReporting.setReportTypes(reportTypesArray);
    }

    @Override
    public void setExtendedBugReportMode(@NonNull String mode) {
        final ExtendedBugReport.State resolvedMode = ArgsRegistry.extendedBugReportStates.get(mode);
        BugReporting.setExtendedBugReportState(resolvedMode);
    }

    @SuppressLint("WrongConstant")
    @Override
    public void setInvocationOptions(@NonNull List<String> options) {
        int[] resolvedOptions = new int[options.size()];
        for (int i = 0; i < options.size(); i++) {
            resolvedOptions[i] = ArgsRegistry.invocationOptions.get(options.get(i));
        }
        BugReporting.setOptions(resolvedOptions);
    }

    @Override
    public void setFloatingButtonEdge(@NonNull String edge, @NonNull Long offset) {
        final InstabugFloatingButtonEdge resolvedEdge = ArgsRegistry.floatingButtonEdges.get(edge);
        BugReporting.setFloatingButtonEdge(resolvedEdge);
        BugReporting.setFloatingButtonOffset(offset.intValue());
    }

    @Override
    public void setVideoRecordingFloatingButtonPosition(@NonNull String position) {
        final InstabugVideoRecordingButtonPosition resolvedPosition = ArgsRegistry.recordButtonPositions.get(position);
        BugReporting.setVideoRecordingFloatingButtonPosition(resolvedPosition);
    }

    @Override
    public void setShakingThresholdForiPhone(@NonNull Double threshold) {
        // iOS Only
    }

    @Override
    public void setShakingThresholdForiPad(@NonNull Double threshold) {
        // iOS Only
    }

    @Override
    public void setShakingThresholdForAndroid(@NonNull Long threshold) {
        BugReporting.setShakingThreshold(threshold.intValue());
    }

    @Override
    public void setEnabledAttachmentTypes(@NonNull Boolean screenshot, @NonNull Boolean extraScreenshot, @NonNull Boolean galleryImage, @NonNull Boolean screenRecording) {
        BugReporting.setAttachmentTypesEnabled(screenshot, extraScreenshot, galleryImage, screenRecording);
    }

    @Override
    public void bindOnInvokeCallback() {
        BugReporting.setOnInvokeCallback(new OnInvokeCallback() {
            @Override
            public void onInvoke() {
                // The on invoke callback for Flutter needs to be run on the
                // main thread, otherwise, it won't work and will break the
                // Instabug.show API
                ThreadManager.runOnMainThread(new Runnable() {
                    @Override
                    public void run() {
                        flutterApi.onSdkInvoke(new BugReportingPigeon.BugReportingFlutterApi.Reply<Void>() {
                            @Override
                            public void reply(Void reply) {
                            }
                        });
                    }
                });
            }
        });
    }

    @Override
    public void bindOnDismissCallback() {
        BugReporting.setOnDismissCallback(new OnSdkDismissCallback() {
            @Override
            public void call(DismissType dismissType, ReportType reportType) {
                ThreadManager.runOnMainThread(new Runnable() {
                    @Override
                    public void run() {
                        flutterApi.onSdkDismiss(dismissType.toString(), reportType.toString(), new BugReportingPigeon.BugReportingFlutterApi.Reply<Void>() {
                            @Override
                            public void reply(Void reply) {
                            }
                        });
                    }
                });
            }
        });
    }

    @Override
    public void setDisclaimerText(@NonNull String text) {
        BugReporting.setDisclaimerText(text);
    }

    @SuppressLint("WrongConstant")
    @Override
    public void setCommentMinimumCharacterCount(@NonNull Long limit, @Nullable List<String> reportTypes) {
        int[] reportTypesArray = reportTypes == null ? new int[0] : new int[reportTypes.size()];
        if(reportTypes != null){
        for (int i = 0; i < reportTypes.size(); i++) {
            String key = reportTypes.get(i);
            reportTypesArray[i] = ArgsRegistry.reportTypes.get(key);
        }
    }
        BugReporting.setCommentMinimumCharacterCountForBugReportType(limit.intValue(), reportTypesArray);
    }

    @Override
public void addUserConsents(String key, String description, Boolean mandatory, Boolean checked, String actionType) {
        ThreadManager.runOnMainThread(new Runnable() {
        @Override
        public void run() {
            String mappedActionType;
            try {
                if (actionType==null) {
                    mappedActionType = null;
                }
                else {
                    mappedActionType = ArgsRegistry.userConsentActionType.get(actionType);
                }

                BugReporting.addUserConsent(key, description, mandatory, checked, mappedActionType);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    });
}
}
