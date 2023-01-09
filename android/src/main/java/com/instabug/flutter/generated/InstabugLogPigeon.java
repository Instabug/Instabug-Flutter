// Autogenerated from Pigeon (v3.0.4), do not edit directly.
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
public class InstabugLogPigeon {
  private static class InstabugLogHostApiCodec extends StandardMessageCodec {
    public static final InstabugLogHostApiCodec INSTANCE = new InstabugLogHostApiCodec();
    private InstabugLogHostApiCodec() {}
  }

  /** Generated interface from Pigeon that represents a handler of messages from Flutter.*/
  public interface InstabugLogHostApi {
    void logVerbose(@NonNull String message);
    void logDebug(@NonNull String message);
    void logInfo(@NonNull String message);
    void logWarn(@NonNull String message);
    void logError(@NonNull String message);
    void clearAllLogs();

    /** The codec used by InstabugLogHostApi. */
    static MessageCodec<Object> getCodec() {
      return InstabugLogHostApiCodec.INSTANCE;
    }

    /** Sets up an instance of `InstabugLogHostApi` to handle messages through the `binaryMessenger`. */
    static void setup(BinaryMessenger binaryMessenger, InstabugLogHostApi api) {
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.InstabugLogHostApi.logVerbose", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              ArrayList<Object> args = (ArrayList<Object>)message;
              String messageArg = (String)args.get(0);
              if (messageArg == null) {
                throw new NullPointerException("messageArg unexpectedly null.");
              }
              api.logVerbose(messageArg);
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
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.InstabugLogHostApi.logDebug", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              ArrayList<Object> args = (ArrayList<Object>)message;
              String messageArg = (String)args.get(0);
              if (messageArg == null) {
                throw new NullPointerException("messageArg unexpectedly null.");
              }
              api.logDebug(messageArg);
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
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.InstabugLogHostApi.logInfo", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              ArrayList<Object> args = (ArrayList<Object>)message;
              String messageArg = (String)args.get(0);
              if (messageArg == null) {
                throw new NullPointerException("messageArg unexpectedly null.");
              }
              api.logInfo(messageArg);
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
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.InstabugLogHostApi.logWarn", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              ArrayList<Object> args = (ArrayList<Object>)message;
              String messageArg = (String)args.get(0);
              if (messageArg == null) {
                throw new NullPointerException("messageArg unexpectedly null.");
              }
              api.logWarn(messageArg);
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
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.InstabugLogHostApi.logError", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              ArrayList<Object> args = (ArrayList<Object>)message;
              String messageArg = (String)args.get(0);
              if (messageArg == null) {
                throw new NullPointerException("messageArg unexpectedly null.");
              }
              api.logError(messageArg);
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
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.InstabugLogHostApi.clearAllLogs", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              api.clearAllLogs();
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
