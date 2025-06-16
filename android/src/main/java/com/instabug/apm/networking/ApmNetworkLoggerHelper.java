package com.instabug.apm.networking;


import androidx.annotation.NonNull;

import com.instabug.apm.networking.mapping.NetworkRequestAttributes;
import com.instabug.apm.networkinterception.cp.APMCPNetworkLog;

import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

public class ApmNetworkLoggerHelper {

    /// Log network request to the Android SDK using a package private API [APMNetworkLogger.log]
    static public void log(@NonNull Map<String, Object> data) {
        try {
            APMNetworkLogger apmNetworkLogger = new APMNetworkLogger();
            final String requestUrl = (String) data.get("url");
            final String requestBody = (String) data.get("requestBody");
            final String responseBody = (String) data.get("responseBody");
            final String requestMethod = (String) data.get("method");
            //--------------------------------------------
            final String requestContentType = (String) data.get("requestContentType");
            final String responseContentType = (String) data.get("responseContentType");
            //--------------------------------------------
            final long requestBodySize = ((Number) data.get("requestBodySize")).longValue();
            final long responseBodySize = ((Number) data.get("responseBodySize")).longValue();
            //--------------------------------------------
            final String errorDomain = (String) data.get("errorDomain");
            final Integer statusCode = (Integer) data.get("responseCode");
            final long requestDuration = ((Number) data.get("duration")).longValue() / 1000;
            final long requestStartTime = ((Number) data.get("startTime")).longValue() * 1000;
            final String requestHeaders = (new JSONObject((HashMap<String, String>) data.get("requestHeaders"))).toString(4);
            final String responseHeaders = (new JSONObject((HashMap<String, String>) data.get("responseHeaders"))).toString(4);
            final String errorMessage;

            if (errorDomain.equals("")) {
                errorMessage = null;
            } else {
                errorMessage = errorDomain;
            }
            //--------------------------------------------------
            String gqlQueryName = null;
            if (data.containsKey("gqlQueryName")) {
                gqlQueryName = (String) data.get("gqlQueryName");
            }
            String serverErrorMessage = "";
            if (data.containsKey("serverErrorMessage")) {
                serverErrorMessage = (String) data.get("serverErrorMessage");
            }
            Boolean isW3cHeaderFound = null;
            Number partialId = null;
            Number networkStartTimeInSeconds = null;
            String w3CGeneratedHeader = null;
            String w3CCaughtHeader = null;

            if (data.containsKey("isW3cHeaderFound")) {
                isW3cHeaderFound = (Boolean) data.get("isW3cHeaderFound");
            }

            if (data.containsKey("partialId")) {


                partialId = ((Number) data.get("partialId"));

            }
            if (data.containsKey("networkStartTimeInSeconds")) {
                networkStartTimeInSeconds = ((Number) data.get("networkStartTimeInSeconds"));
            }

            if (data.containsKey("w3CGeneratedHeader")) {

                w3CGeneratedHeader = (String) data.get("w3CGeneratedHeader");


            }
            if (data.containsKey("w3CCaughtHeader")) {
                w3CCaughtHeader = (String) data.get("w3CCaughtHeader");

            }

            NetworkRequestAttributes requestAttributes = new NetworkRequestAttributes(
                    requestStartTime * 1000,
                    requestDuration,
                    requestHeaders,
                    requestBody,
                    requestBodySize,
                    requestMethod,
                    requestUrl,
                    requestContentType,
                    responseHeaders,
                    responseBody,
                    responseBodySize,
                    statusCode,
                    responseContentType,
                    gqlQueryName,
                    errorMessage,
                    serverErrorMessage
            );

            APMCPNetworkLog.W3CExternalTraceAttributes w3cExternalTraceAttributes =
                    null;
            if (isW3cHeaderFound != null) {
                w3cExternalTraceAttributes = new APMCPNetworkLog.W3CExternalTraceAttributes(
                        isW3cHeaderFound, partialId == null ? null : partialId.longValue(),
                        networkStartTimeInSeconds == null ? null : networkStartTimeInSeconds.longValue(),
                        w3CGeneratedHeader, w3CCaughtHeader

                );
            }

            apmNetworkLogger.log(requestAttributes, w3cExternalTraceAttributes);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
