// Autogenerated from Pigeon (v3.2.9), do not edit directly.
// See also: https://pub.dev/packages/pigeon

package com.instabug.flutter.generated;

import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MessageCodec;
import io.flutter.plugin.common.StandardMessageCodec;
import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

/** Generated class from Pigeon. */
@SuppressWarnings({"unused", "unchecked", "CodeBlock2Expr", "RedundantSuppression"})
public class SurveysPigeon {

  public interface Result<T> {
    void success(T result);
    void error(Throwable error);
  }
  private static class SurveysFlutterApiCodec extends StandardMessageCodec {
    public static final SurveysFlutterApiCodec INSTANCE = new SurveysFlutterApiCodec();
    private SurveysFlutterApiCodec() {}
  }

  /** Generated class from Pigeon that represents Flutter messages that can be called from Java.*/
  public static class SurveysFlutterApi {
    private final BinaryMessenger binaryMessenger;
    public SurveysFlutterApi(BinaryMessenger argBinaryMessenger){
      this.binaryMessenger = argBinaryMessenger;
    }
    public interface Reply<T> {
      void reply(T reply);
    }
    static MessageCodec<Object> getCodec() {
      return SurveysFlutterApiCodec.INSTANCE;
    }

    public void onShowSurvey(Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.SurveysFlutterApi.onShowSurvey", getCodec());
      channel.send(null, channelReply -> {
        callback.reply(null);
      });
    }
    public void onDismissSurvey(Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.SurveysFlutterApi.onDismissSurvey", getCodec());
      channel.send(null, channelReply -> {
        callback.reply(null);
      });
    }
  }
  private static class SurveysHostApiCodec extends StandardMessageCodec {
    public static final SurveysHostApiCodec INSTANCE = new SurveysHostApiCodec();
    private SurveysHostApiCodec() {}
  }

  /** Generated interface from Pigeon that represents a handler of messages from Flutter.*/
  public interface SurveysHostApi {
    void setEnabled(@NonNull Boolean isEnabled);
    void showSurveyIfAvailable();
    void showSurvey(@NonNull String surveyToken);
    void setAutoShowingEnabled(@NonNull Boolean isEnabled);
    void setShouldShowWelcomeScreen(@NonNull Boolean shouldShowWelcomeScreen);
    void setAppStoreURL(@NonNull String appStoreURL);
    void hasRespondedToSurvey(@NonNull String surveyToken, Result<Boolean> result);
    void getAvailableSurveys(Result<List<String>> result);
    void bindOnShowSurveyCallback();
    void bindOnDismissSurveyCallback();

    /** The codec used by SurveysHostApi. */
    static MessageCodec<Object> getCodec() {
      return SurveysHostApiCodec.INSTANCE;
    }

    /** Sets up an instance of `SurveysHostApi` to handle messages through the `binaryMessenger`. */
    static void setup(BinaryMessenger binaryMessenger, SurveysHostApi api) {
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.SurveysHostApi.setEnabled", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              ArrayList<Object> args = (ArrayList<Object>)message;
              Boolean isEnabledArg = (Boolean)args.get(0);
              if (isEnabledArg == null) {
                throw new NullPointerException("isEnabledArg unexpectedly null.");
              }
              api.setEnabled(isEnabledArg);
              wrapped.put("result", null);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.SurveysHostApi.showSurveyIfAvailable", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              api.showSurveyIfAvailable();
              wrapped.put("result", null);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.SurveysHostApi.showSurvey", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              ArrayList<Object> args = (ArrayList<Object>)message;
              String surveyTokenArg = (String)args.get(0);
              if (surveyTokenArg == null) {
                throw new NullPointerException("surveyTokenArg unexpectedly null.");
              }
              api.showSurvey(surveyTokenArg);
              wrapped.put("result", null);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.SurveysHostApi.setAutoShowingEnabled", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              ArrayList<Object> args = (ArrayList<Object>)message;
              Boolean isEnabledArg = (Boolean)args.get(0);
              if (isEnabledArg == null) {
                throw new NullPointerException("isEnabledArg unexpectedly null.");
              }
              api.setAutoShowingEnabled(isEnabledArg);
              wrapped.put("result", null);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.SurveysHostApi.setShouldShowWelcomeScreen", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              ArrayList<Object> args = (ArrayList<Object>)message;
              Boolean shouldShowWelcomeScreenArg = (Boolean)args.get(0);
              if (shouldShowWelcomeScreenArg == null) {
                throw new NullPointerException("shouldShowWelcomeScreenArg unexpectedly null.");
              }
              api.setShouldShowWelcomeScreen(shouldShowWelcomeScreenArg);
              wrapped.put("result", null);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.SurveysHostApi.setAppStoreURL", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              ArrayList<Object> args = (ArrayList<Object>)message;
              String appStoreURLArg = (String)args.get(0);
              if (appStoreURLArg == null) {
                throw new NullPointerException("appStoreURLArg unexpectedly null.");
              }
              api.setAppStoreURL(appStoreURLArg);
              wrapped.put("result", null);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.SurveysHostApi.hasRespondedToSurvey", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              ArrayList<Object> args = (ArrayList<Object>)message;
              String surveyTokenArg = (String)args.get(0);
              if (surveyTokenArg == null) {
                throw new NullPointerException("surveyTokenArg unexpectedly null.");
              }
              Result<Boolean> resultCallback = new Result<Boolean>() {
                public void success(Boolean result) {
                  wrapped.put("result", result);
                  reply.reply(wrapped);
                }
                public void error(Throwable error) {
                  wrapped.put("error", wrapError(error));
                  reply.reply(wrapped);
                }
              };

              api.hasRespondedToSurvey(surveyTokenArg, resultCallback);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
              reply.reply(wrapped);
            }
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.SurveysHostApi.getAvailableSurveys", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              Result<List<String>> resultCallback = new Result<List<String>>() {
                public void success(List<String> result) {
                  wrapped.put("result", result);
                  reply.reply(wrapped);
                }
                public void error(Throwable error) {
                  wrapped.put("error", wrapError(error));
                  reply.reply(wrapped);
                }
              };

              api.getAvailableSurveys(resultCallback);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
              reply.reply(wrapped);
            }
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.SurveysHostApi.bindOnShowSurveyCallback", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              api.bindOnShowSurveyCallback();
              wrapped.put("result", null);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.SurveysHostApi.bindOnDismissSurveyCallback", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              api.bindOnDismissSurveyCallback();
              wrapped.put("result", null);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
    }
  }
  private static Map<String, Object> wrapError(Throwable exception) {
    Map<String, Object> errorMap = new HashMap<>();
    errorMap.put("message", exception.toString());
    errorMap.put("code", exception.getClass().getSimpleName());
    errorMap.put("details", "Cause: " + exception.getCause() + ", Stacktrace: " + Log.getStackTraceString(exception));
    return errorMap;
  }
}
