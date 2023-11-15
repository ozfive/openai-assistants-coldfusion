/*
    USAGE:
        
        // Create an instance of APICommunication
        apiComm = new APICommunication();
*/
component {

    // Define the APIKey variable
    variables.APIKey = "";

    //
    // Request/Response Functions
    ///////////////////////////////////////////////////////////////////////////

    // Function to configure HTTP request
    function configureHttpRequest(httpRequest, method, endpoint, req) {
        httpRequest.setURL("https://api.openai.com/v1/" & endpoint);
        httpRequest.setMethod(method);
        httpRequest.addParam(type="header", name="Content-Type", value="application/json");
        httpRequest.addParam(type="header", name="Authorization", value="Bearer " & variables.APIKey);
        httpRequest.addParam(type="header", name="OpenAI-Beta", value="assistants=v1");

        // Convert request struct to JSON and set it as the request body
        if (structKeyExists(req, "Instructions")) {
            var requestBody = serializeJSON({
                "instructions": req.Instructions,
                "name": req.Name,
                "tools": req.Tools,
                "model": req.Model
                // Add other parameters as needed
            });
            httpRequest.setBody(requestBody);
        }
    }

    // Function to send HTTP request with retries and backoff
    function sendHttpRequest(httpRequest, maxRetries) {
        var currentRetry = 0;

        while (currentRetry lt maxRetries) {
            try {
                var httpResponse = httpRequest.send();
                return httpResponse;
            } catch (java.net.SocketTimeoutException e) {
                // Handle timeout exception
                currentRetry++;

                // Exponential backoff: wait for an increasing amount of time between retries
                var waitTime = 2^currentRetry * 1000; // wait in milliseconds
                sleep(waitTime);

                if (currentRetry lt maxRetries) {
                    var logOutput = "Retry ##" & currentRetry & " due to timeout. Will retry up to " & maxRetries & " times.";
                    writeLog(text=logOutput, type="info");
                } else {
                    var exceptionMessage = "HTTP request failed with timeout after " & maxRetries & " attempts.";
                    throw exceptionMessage;
                }
            } catch (any e) {
                // Handle other exceptions
                var unexpectedException = "An unexpected error occurred: " & e.getMessage();
                logFullExceptionDetails(unexpectedException);
                throw unexpectedException;
            }
        }
    }

    // Function to log full exception details
    function logFullExceptionDetails(message) {
        var exceptionDetails = "Exception Details: " & getMessageDetails(message);
        writeLog(text=exceptionDetails, type="error");
    }

    // Function to get message details including the stack trace
    function getMessageDetails(message) {
        var details = message & " Stack Trace: " & getStackTrace();
        return details;
    }

   // Function to handle HTTP response
    function handleHttpResponse(result, httpResponse) {
        var statusCode = httpResponse.getStatusCode();
        result.status = statusCode;

        // Log the entire HTTP response for debugging
        writeLog("HTTP Response: " & httpResponse.toString(), "debug");

        if (statusCode eq 200 or statusCode eq 201 or statusCode eq 204) {
            if (len(httpResponse.fileContent)) {
                result.data = deserializeJSON(httpResponse.fileContent);
            }
        } else {
            var errorResponse = deserializeJSON(httpResponse.getAsString());

            // Handle specific HTTP status codes
            switch (statusCode) {
                case 400:
                    result.error = "Bad Request: " & errorResponse.error.message;
                    break;
                case 401:
                    result.error = "Unauthorized: " & errorResponse.error.message;
                    break;
                case 403:
                    result.error = "Forbidden: " & errorResponse.error.message;
                    break;
                case 404:
                    result.error = "Not Found: " & errorResponse.error.message;
                    break;
                case 500:
                    result.error = "Internal Server Error: " & errorResponse.error.message;
                    break;
                default:
                    result.error = "HTTP request failed with status code: " & statusCode & ". " & errorResponse.error.message;
                    break;
            }

            result.errorCode = errorResponse.error.code;
            result.errorType = errorResponse.error.type;
            result.errorParam = errorResponse.error.param;
        }
    }

    // Function to log errors
    function logError(message) {
        cflog(file="error", text=message);
    }
}
