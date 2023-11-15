/*
    USAGE:
    
        <cfscript>
            // Create an instance of APICommunication
            apiComm = new APICommunication();

            // Create an instance of ThreadsManager and pass apiComm to it
            threadsManager = new ThreadsManager(apiComm);

            // Now you can use messagesManager to create an assistant
            result = threadsManager.CreateThread(messages="");
        </cfscript>
*/

component {

    property name="apiComm" type="APICommunication";

    function init(APICommunication apiCommInstance) {
        this.apiComm = apiCommInstance;
        return this;
    }

    // Thread Functions
    ///////////////////////////////////////////////////////////////////////////

    // Function to create a thread
    function CreateThread(messages) {
        var result = {};
        var httpRequest = new cfhttp();

        try {
            // Input Validation
            if (not isArray(messages) or arrayLen(messages) eq 0) {
                result.error = "Invalid input: messages must be a non-empty array.";
                apiComm.logError(result.error);
                return result;
            }

            for (var i = 1; i <= arrayLen(messages); i++) {
                if (not structKeyExists(messages[i], "role") or not isValid("string", messages[i].role) or
                    not structKeyExists(messages[i], "content") or not isValid("string", messages[i].content)) {
                    result.error = "Invalid message format at index #i#.";
                    apiComm.logError(result.error);
                    return result;
                }
            }

            // Set up HTTP request
            apiComm.configureHttpRequest(httpRequest, "POST", "threads", {"messages": messages});

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

    // Function to retrieve a thread
    function RetrieveThread(threadId) {
        var result = {};
        var httpRequest = new cfhttp();

        try {
            // Input Validation
            if (not isValid("string", threadId)) {
                result.error = "Invalid input: Thread ID must be a valid string.";
                apiComm.logError(result.error);
                return result;
            }

            // Set up HTTP request
            apiComm.configureHttpRequest(httpRequest, "GET", "threads/#threadId#", {});

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

    // Function to modify a thread
    function ModifyThread(threadId, metadata) {
        var result = {};
        var httpRequest = new cfhttp();

        try {
            // Input Validation
            if (not isValid("string", threadId)) {
                result.error = "Invalid input: Thread ID must be a valid string.";
                apiComm.logError(result.error);
                return result;
            }
            if (not isStruct(metadata)) {
                result.error = "Invalid input: Metadata must be a struct.";
                apiComm.logError(result.error);
                return result;
            }

            // Set up HTTP request
            apiComm.configureHttpRequest(httpRequest, "POST", "threads/#threadId#", {"metadata": metadata});

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

    // Function to delete a thread
    function DeleteThread(threadId) {
        var result = {};
        var httpRequest = new cfhttp();

        try {
            // Input Validation
            if (not isValid("string", threadId)) {
                result.error = "Invalid input: Thread ID must be a valid string.";
                apiComm.logError(result.error);
                return result;
            }

            // Set up HTTP request
            apiComm.configureHttpRequest(httpRequest, "DELETE", "threads/#threadId#", {});

            var maxRetries = 3;
            var httpResponse = apiComm.sendHttpRequest(httpRequest, maxRetries);

            // Handle HTTP response
            apiComm.handleHttpResponse(result, httpResponse);

            // Check for errors
            if (structKeyExists(result, "error")) {
                // Log the error
                apiComm.logError(result.error);
            } else {
                // Operation was successful, result.data indicates deletion status
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