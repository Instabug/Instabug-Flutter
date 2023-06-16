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
public class CrashReportingPigeon {
  private static class CrashReportingHostApiCodec extends StandardMessageCodec {
    public static final CrashReportingHostApiCodec INSTANCE = new CrashReportingHostApiCodec();
    private CrashReportingHostApiCodec() {}
  }

  /** Generated interface from Pigeon that represents a handler of messages from Flutter.*/
  public interface CrashReportingHostApi {
    void setEnabled(@NonNull Boolean isEnabled);
    void send(@NonNull String jsonCrash, @NonNull Boolean isHandled);

    /** The codec used by CrashReportingHostApi. */
    static MessageCodec<Object> getCodec() {
      return CrashReportingHostApiCodec.INSTANCE;
    }

    /** Sets up an instance of `CrashReportingHostApi` to handle messages through the `binaryMessenger`. */
    static void setup(BinaryMessenger binaryMessenger, CrashReportingHostApi api) {
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.CrashReportingHostApi.setEnabled", getCodec());
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
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.CrashReportingHostApi.send", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              ArrayList<Object> args = (ArrayList<Object>)message;
              String jsonCrashArg = (String)args.get(0);
              if (jsonCrashArg == null) {
                throw new NullPointerException("jsonCrashArg unexpectedly null.");
              }
              Boolean isHandledArg = (Boolean)args.get(1);
              if (isHandledArg == null) {
                throw new NullPointerException("isHandledArg unexpectedly null.");
              }
              api.send(jsonCrashArg, isHandledArg);
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
