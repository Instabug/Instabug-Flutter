package com.instabug.flutter.util;

import com.instabug.flutter.generated.ApmPigeon;
import com.instabug.flutter.generated.InstabugPigeon;
import com.instabug.flutter.generated.RepliesPigeon;
import com.instabug.flutter.generated.SurveysPigeon;

interface Result<T> extends ApmPigeon.Result<T>, InstabugPigeon.Result<T>, RepliesPigeon.Result<T>, SurveysPigeon.Result<T> {
    void success(T result);

    void error(Throwable error);
}

public class MockResult {
    public static <T> Result<T> makeResult(Callback<T> success, Callback<Throwable> error) {
        return new Result<T>() {
            @Override
            public void success(T result) {
                success.callback(result);
            }

            @Override
            public void error(Throwable exception) {
                error.callback(exception);
            }
        };
    }

    public static <T> Result<T> makeResult(Callback<T> success) {
        return makeResult(success, (Throwable) -> {});
    }

    public static <T> Result<T> makeResult() {
        return makeResult((T) -> {}, (Throwable) -> {});
    }
}
