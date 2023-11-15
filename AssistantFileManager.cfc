/*
    USAGE:
    
        <cfscript>
            // Create an instance of APICommunication
            apiComm = new APICommunication();

            // Create an instance of AssistantFileManager and pass apiComm to it
            assistantFileManager = new AssistantFileManager(apiComm);

            // Now you can use assistantFileManager to create an assistant
            result = assistantFileManager.CreateAssistantFile(assistantId="assistant_ID", fileId="file_ID");
        </cfscript>
*/

component {
    
    property name="apiComm" type="APICommunication";

    function init(APICommunication apiCommInstance) {
        this.apiComm = apiCommInstance;
        return this;
    }

    // Assistant File Functions
    ///////////////////////////////////////////////////////////////////////////
    
    // Function to create an assistant file
    function CreateAssistantFile(assistantId, fileId) {
        var result = {};
        var httpRequest = new cfhttp();

        try {
            // Input Validation
            if (not isValid("string", assistantId) or not isValid("string", fileId)) {
                result.error = "Invalid input parameters.";
                apiComm.logError("Invalid input parameters.");
                return result;
            }

            // Set up HTTP request
            apiComm.configureHttpRequest(httpRequest, "POST", "assistants/#assistantId#/files", {"file_id": fileId});

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

    // Function to retrieve an assistant file
    function RetrieveAssistantFile(assistantId, fileId) {
        var result = {};
        var httpRequest = new cfhttp();

        try {
            // Input Validation
            if (not isValid("string", assistantId) or not isValid("string", fileId)) {
                result.error = "Invalid input parameters.";
                apiComm.logError("Invalid input parameters.");
                return result;
            }

            // Set up HTTP request
            apiComm.configureHttpRequest(httpRequest, "GET", "assistants/#assistantId#/files/#fileId#", {});

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

    // Function to delete an assistant file
    function DeleteAssistantFile(assistantId, fileId) {
        var result = {};
        var httpRequest = new cfhttp();

        try {
            // Input Validation
            if (not isValid("string", assistantId) or not isValid("string", fileId)) {
                result.error = "Invalid input parameters.";
                apiComm.logError("Invalid input parameters.");
                return result;
            }

            // Set up HTTP request
            apiComm.configureHttpRequest(httpRequest, "DELETE", "assistants/#assistantId#/files/#fileId#", {});

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

    // Function to list assistant files
    function ListAssistantFiles(assistantId, limit, order, after, before) {
        var result = {};
        var httpRequest = new cfhttp();

        try {
            // Input Validation
            if (not isValid("string", assistantId)) {
                result.error = "Invalid assistant ID.";
                apiComm.logError("Invalid assistant ID.");
                return result;
            }

            // Construct query parameters
            var queryParams = {};
            if (isDefined("limit") and isNumeric(limit) and limit gte 1 and limit lte 100) queryParams["limit"] = limit;
            if (isDefined("order") and (order eq "asc" or order eq "desc")) queryParams["order"] = order;
            if (isDefined("after")) queryParams["after"] = after;
            if (isDefined("before")) queryParams["before"] = before;

            apiComm.configureHttpRequest(httpRequest, "GET", "assistants/#assistantId#/files", queryParams);

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