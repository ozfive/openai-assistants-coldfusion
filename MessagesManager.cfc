/*
    USAGE:
    
        <cfscript>
            // Create an instance of APICommunication
            apiComm = new APICommunication();

            // Create an instance of MessagesManager and pass apiComm to it
            messagesManager = new MessagesManager(apiComm);

            // Now you can use messagesManager to create an assistant
            result = messagesManager.CreateMessage(threadId="Thread_ID", role="user", content="[MESSAGE CONTENT]", fileIds="", metadata="");
        </cfscript>
*/

component {
    
    property name="apiComm" type="APICommunication";

    function init(APICommunication apiCommInstance) {
        this.apiComm = apiCommInstance;
        return this;
    }
    
    // Messages In Threads Functions
    ///////////////////////////////////////////////////////////////////////////

    // Function to create a message in a thread
    function CreateMessage(threadId, role, content, fileIds, metadata) {
        var result = {};
        var httpRequest = new cfhttp();

        try {
            // Input Validation
            if (not isValid("string", threadId)) {
                result.error = "Invalid input: Thread ID must be a valid string.";
                apiComm.logError(result.error);
                return result;
            }
            if (role neq "user") {
                result.error = "Invalid input: Currently, only 'user' role is supported.";
                apiComm.logError(result.error);
                return result;
            }
            if (not isValid("string", content)) {
                result.error = "Invalid input: Content must be a valid string.";
                apiComm.logError(result.error);
                return result;
            }
            if (isDefined("fileIds") and not isArray(fileIds)) {
                result.error = "Invalid input: File IDs must be an array.";
                apiComm.logError(result.error);
                return result;
            }
            if (isDefined("metadata") and not isStruct(metadata)) {
                result.error = "Invalid input: Metadata must be a struct.";
                apiComm.logError(result.error);
                return result;
            }

            // Prepare request body
            var requestBody = {
                "role": role,
                "content": content
            };
            if (isArray(fileIds)) {
                requestBody.file_ids = fileIds;
            }
            if (isStruct(metadata)) {
                requestBody.metadata = metadata;
            }

            // Set up HTTP request
            apiComm.configureHttpRequest(httpRequest, "POST", "threads/#threadId#/messages", requestBody);

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

    // Function to retrieve a message
    function RetrieveMessage(threadId, messageId) {
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

            // Set up HTTP request
            apiComm.configureHttpRequest(httpRequest, "GET", "threads/#threadId#/messages/#messageId#", {});

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

    // Function to modify a message
    function ModifyMessage(threadId, messageId, metadata) {
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
            if (isDefined("metadata") and not isStruct(metadata)) {
                result.error = "Invalid input: Metadata must be a struct.";
                apiComm.logError(result.error);
                return result;
            }

            // Prepare request body
            var requestBody = {};
            if (isStruct(metadata)) {
                requestBody.metadata = metadata;
            }

            // Set up HTTP request
            apiComm.configureHttpRequest(httpRequest, "POST", "threads/#threadId#/messages/#messageId#", requestBody);

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

    // Function to list messages in a thread
    function ListMessages(threadId, limit, order, after, before) {
        var result = {};
        var httpRequest = new cfhttp();

        try {
            // Input Validation
            if (not isValid("string", threadId)) {
                result.error = "Invalid input: Thread ID must be a valid string.";
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
            apiComm.configureHttpRequest(httpRequest, "GET", "threads/#threadId#/messages", queryParams);

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