/*
    USAGE:
    
        <cfscript>
            // Create an instance of APICommunication
            apiComm = new APICommunication();

            // Create an instance of MessageFilesManager and pass apiComm to it
            messageFilesManager = new MessageFilesManager(apiComm);

            // Now you can use assistantManager to create an assistant
            result = messageFilesManager.RetrieveMessageFile(threadId="Thread_ID", messageId="Message_ID", fileId="");
        </cfscript>
*/

component {

    property name="apiComm" type="APICommunication";

    function init(APICommunication apiCommInstance) {
        this.apiComm = apiCommInstance;
        return this;
    }

    // Message Files Functions
    ///////////////////////////////////////////////////////////////////////////

    // Function to retrieve a message file
    function RetrieveMessageFile(threadId, messageId, fileId) {
        var result = {};
        var httpRequest = new cfhttp();

        try {
            // Input Validation
            if (not isValid("string", threadId)) {
                result.error = "Invalid input: Thread ID must be a valid string.";
                apiComm.logError(result.error);
                return result;
            }
            if (not isValid("string", messageId)) {
                result.error = "Invalid input: Message ID must be a valid string.";
                apiComm.logError(result.error);
                return result;
            }
            if (not isValid("string", fileId)) {
                result.error = "Invalid input: File ID must be a valid string.";
                apiComm.logError(result.error);
                return result;
            }

            // Set up HTTP request
            apiComm.configureHttpRequest(httpRequest, "GET", "threads/#threadId#/messages/#messageId#/files/#fileId#", {});

            var maxRetries = 3;
            var httpResponse = apiComm.sendHttpRequest(httpRequest, maxRetries);

            // Handle HTTP response
            apiComm.handleHttpResponse(result, httpResponse);

            // Check for errors
            if (structKeyExists(result, "error")) {
                // Log the error
                apiComm.logError(result.error);
            } else {
                // Operation was successful, result.data contains the parsed JSON data
                // You can use the data as needed
            }
        } catch (any e) {
            // Log unexpected errors
            apiComm.logError("An unexpected error occurred: " & e.getMessage());
            result.error = "An unexpected error occurred: " & e.getMessage();
        }

        return result;
    }

    // Function to list message files
    function ListMessageFiles(threadId, messageId, limit, order, after, before) {
        var result = {};
        var httpRequest = new cfhttp();

        try {
            // Input Validation
            if (not isValid("string", threadId)) {
                result.error = "Invalid input: Thread ID must be a valid string.";
                apiComm.logError(result.error);
                return result;
            }
            if (not isValid("string", messageId)) {
                result.error = "Invalid input: Message ID must be a valid string.";
                apiComm.logError(result.error);
                return result;
            }

            // Construct query parameters
            var queryParams = {};
            if (isDefined("limit") and isNumeric(limit) and limit gte 1 and limit lte 100) queryParams["limit"] = limit;
            if (isDefined("order") and (order eq "asc" or order eq "desc")) queryParams["order"] = order;
            if (isDefined("after")) queryParams["after"] = after;
            if (isDefined("before")) queryParams["before"] = before;

            // Set up HTTP request
            apiComm.configureHttpRequest(httpRequest, "GET", "threads/#threadId#/messages/#messageId#/files", queryParams);

            var maxRetries = 3;
            var httpResponse = apiComm.sendHttpRequest(httpRequest, maxRetries);

            // Handle HTTP response
            apiComm.handleHttpResponse(result, httpResponse);

            // Check for errors
            if (structKeyExists(result, "error")) {
                // Log the error
                apiComm.logError(result.error);
            } else {
                // Operation was successful, result.data contains the parsed JSON data
                // You can use the data as needed
            }
        } catch (any e) {
            // Log unexpected errors
            apiComm.logError("An unexpected error occurred: " & e.getMessage());
            result.error = "An unexpected error occurred: " & e.getMessage();
        }

        return result;
    }
}