/*
    USAGE:

        <cfscript>
            requestStruct = {
                Instructions = "Your instructions here",
                Model = "Your model information",
                Tools = ["Tool1", "Tool2"], // Array of tools
                FileIDs = ["FileID1", "FileID2"] // Array of file IDs
            };

            // Create an instance of APICommunication
            apiComm = new APICommunication();

            // Create an instance of AssistantManager and pass apiComm to it
            assistantManager = new AssistantManager(apiComm);

            // Now you can use assistantManager to create an assistant
            result = assistantManager.createAssistant(requestStruct);

            // Process the result as needed
            writeDump(result);
        </cfscript>
*/

component {

    // Define the CreateAssistantRequest struct
    this.Instructions = "";
    this.Model = "";
    this.Tools = [];
    this.FileIDs = [];

    property name="apiComm" type="APICommunication";

    function init(APICommunication apiCommInstance) {
        this.apiComm = apiCommInstance;
        return this;
    }

    // Assistant Functions
    ///////////////////////////////////////////////////////////////////////////

    // Function to create an assistant
    function CreateAssistant(required struct Request) {
        var result = {};
        var httpRequest = new cfhttp();

        try {
            // Input Validation
            if (
                not isValid("struct", Request) or
                not isValid("string", Request.Instructions) or
                not isValid("string", Request.Model)
                // Add further validation as necessary
            ) {
                result.error = "Invalid input parameters.";
                this.apiComm.logError("Invalid input parameters.");
                return result;
            }

            // Configure and send the HTTP request using apiComm
            this.apiComm.configureHttpRequest(httpRequest, "POST", "assistants", request);

            var maxRetries = 3;
            var httpResponse = this.apiComm.sendHttpRequest(httpRequest, maxRetries);
            
            // Handle HTTP response
            this.apiComm.handleHttpResponse(result, httpResponse);

            // Check for errors
            if (structKeyExists(result, "error")) {
                // Log the error
                this.apiComm.logError(result.error);
            } else {
                // Operation was successful, result.data contains the parsed JSON data
                // You can use the data as needed
            }
        } catch (any e) {
            // Log unexpected errors
            this.apiComm.logError("An unexpected error occurred: " & e.getMessage());
            result.error = "An unexpected error occurred: " & e.getMessage();
        }

        return result;
    }

    // Function to retrieve an assistant
    function RetrieveAssistant(assistantId) {
        var result = {};
        var httpRequest = new cfhttp();

        try {
            // Input Validation
            if (not isValid("string", assistantId)) {
                result.error = "Invalid input parameters.";
                apiComm.logError("Invalid input parameters.");
                return result;
            }

            apiComm.configureHttpRequest(httpRequest, "GET", "assistants/" & assistantId, {});
            
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

    // Function to modify an assistant
    function ModifyAssistant(assistantId, req) {
        var result = {};
        var httpRequest = new cfhttp();

        try {
            // Input Validation
            if (
                not isValid("string", assistantId) or
                not isValid("struct", req)
            ) {
                result.error = "Invalid input parameters.";
                apiComm.logError("Invalid input parameters.");
                return result;
            }

            apiComm.configureHttpRequest(httpRequest, "POST", "assistants/" & assistantId, req);

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

    // Function to delete an assistant
    function DeleteAssistant(assistantId) {
        var result = {};
        var httpRequest = new cfhttp();

        try {
            // Input Validation
            if (not isValid("string", assistantId)) {
                result.error = "Invalid input parameters.";
                apiComm.logError("Invalid input parameters.");
                return result;
            }

            apiComm.configureHttpRequest(httpRequest, "DELETE", "assistants/" & assistantId, {});

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

    // Function to list assistants
    function ListAssistants(limit, order, after, before) {
        var result = {};
        var httpRequest = new cfhttp();

        try {
            // Input Validation
            if (
                (isDefined(limit) and (not isNumeric(limit) or limit lt 1 or limit gt 100)) or
                (isDefined(order) and (order neq "asc" and order neq "desc"))
            ) {
                result.error = "Invalid input parameters.";
                apiComm.logError("Invalid input parameters.");
                return result;
            }

            // Construct query parameters
            var queryParams = {};
            if (isDefined(limit)) queryParams["limit"] = limit;
            if (isDefined(order)) queryParams["order"] = order;
            if (isDefined(after)) queryParams["after"] = after;
            if (isDefined(before)) queryParams["before"] = before;

            apiComm.configureHttpRequest(httpRequest, "GET", "assistants", queryParams);

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