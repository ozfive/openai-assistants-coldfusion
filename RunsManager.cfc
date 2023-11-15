/*
    USAGE:
    
        <cfscript>
            // Create an instance of APICommunication
            apiComm = new APICommunication();

            // Create an instance of RunsManager and pass apiComm to it
            runsManager = new RunsManager(apiComm);

            // Now you can use assistantManager to create an assistant
            result = runsManager.CreateRun(threadId="Thread_ID", assistantId="Assistant_ID", model="gpt-4-1106-preview", instructions="You are an HR bot, and you have access to files to answer employee questions about company policies." tools="", metadata="");
        </cfscript>
*/

component {

    property name="apiComm" type="APICommunication";

    function init(APICommunication apiCommInstance) {
        this.apiComm = apiCommInstance;
        return this;
    }

    // Runs Functions
    ///////////////////////////////////////////////////////////////////////////

    // Function to create a run
    function CreateRun(threadId, assistantId, model, instructions, tools, metadata) {
        var result = {};
        var httpRequest = new cfhttp();

        try {
            // Input Validation
            if (not isValid("string", threadId) or not isValid("string", assistantId)) {
                result.error = "Invalid input: Thread ID and Assistant ID must be valid strings.";
                apiComm.logError(result.error);
                return result;
            }

            // Prepare request body
            var requestBody = {
                "assistant_id": assistantId
            };
            if (isDefined("model") and isValid("string", model)) {
                requestBody.model = model;
            }
            if (isDefined("instructions") and isValid("string", instructions)) {
                requestBody.instructions = instructions;
            }
            if (isDefined("tools") and isArray(tools)) {
                requestBody.tools = tools;
            }
            if (isDefined("metadata") and isStruct(metadata)) {
                requestBody.metadata = metadata;
            }

            // Set up HTTP request
            apiComm.configureHttpRequest(httpRequest, "POST", "threads/#threadId#/runs", requestBody);

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

    // Function to retrieve a run
    function RetrieveRun(threadId, runId) {
        var result = {};
        var httpRequest = new cfhttp();

        try {
            // Input Validation
            if (not isValid("string", threadId) or not isValid("string", runId)) {
                result.error = "Invalid input: Thread ID and Run ID must be valid strings.";
                apiComm.logError(result.error);
                return result;
            }

            // Set up HTTP request
            apiComm.configureHttpRequest(httpRequest, "GET", "threads/#threadId#/runs/#runId#", {});

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

    // Function to modify a run
    function ModifyRun(threadId, runId, metadata) {
        var result = {};
        var httpRequest = new cfhttp();

        try {
            // Input Validation
            if (not isValid("string", threadId) or not isValid("string", runId)) {
                result.error = "Invalid input: Thread ID and Run ID must be valid strings.";
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
            apiComm.configureHttpRequest(httpRequest, "POST", "threads/#threadId#/runs/#runId#", requestBody);

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

    // Function to list runs in a thread
    function ListRuns(threadId, limit, order, after, before) {
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
            apiComm.configureHttpRequest(httpRequest, "GET", "threads/#threadId#/runs", queryParams);

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

    // Function to submit tool outputs to a run
    function SubmitToolOutputsToRun(threadId, runId, toolOutputs) {
        var result = {};
        var httpRequest = new cfhttp();

        try {
            // Input Validation
            if (not isValid("string", threadId) or not isValid("string", runId) or not isArray(toolOutputs)) {
                result.error = "Invalid input: Thread ID, Run ID must be valid strings and Tool Outputs must be an array.";
                apiComm.logError(result.error);
                return result;
            }

            // Set up HTTP request
            apiComm.configureHttpRequest(httpRequest, "POST", "threads/#threadId#/runs/#runId#/submit_tool_outputs", {"tool_outputs": toolOutputs});

            var maxRetries = 3;
            var httpResponse = apiComm.sendHttpRequest(httpRequest, maxRetries);

            // Handle HTTP response
            apiComm.handleHttpResponse(result, httpResponse);

            // Check for errors
            if (structKeyExists(result, "error")) {
                // Log the error
                apiComm.logError(result.error);
            } else {
                // Operation was successful, result.data contains the modified run object
                // You can use the data as needed
            }
        } catch (any e) {
            // Log unexpected errors
            apiComm.logError("An unexpected error occurred: " & e.getMessage());
            result.error = "An unexpected error occurred: " & e.getMessage();
        }

        return result;
    }

    // Function to cancel a run
    function CancelRun(threadId, runId) {
        var result = {};
        var httpRequest = new cfhttp();

        try {
            // Input Validation
            if (not isValid("string", threadId) or not isValid("string", runId)) {
                result.error = "Invalid input: Thread ID and Run ID must be valid strings.";
                apiComm.logError(result.error);
                return result;
            }

            // Set up HTTP request
            apiComm.configureHttpRequest(httpRequest, "POST", "threads/#threadId#/runs/#runId#/cancel", {});

            var maxRetries = 3;
            var httpResponse = apiComm.sendHttpRequest(httpRequest, maxRetries);

            // Handle HTTP response
            apiComm.handleHttpResponse(result, httpResponse);

            // Check for errors
            if (structKeyExists(result, "error")) {
                // Log the error
                apiComm.logError(result.error);
            } else {
                // Operation was successful, result.data contains the modified run object
                // You can use the data as needed
            }
        } catch (any e) {
            // Log unexpected errors
            apiComm.logError("An unexpected error occurred: " & e.getMessage());
            result.error = "An unexpected error occurred: " & e.getMessage();
        }

        return result;
    }

    // Function to create a thread and run
    function CreateThreadAndRun(assistantId, thread) {
        var result = {};
        var httpRequest = new cfhttp();

        try {
            // Input Validation
            if (not isValid("string", assistantId)) {
                result.error = "Invalid input: Assistant ID must be a valid string.";
                apiComm.logError(result.error);
                return result;
            }

            // Set up HTTP request
            apiComm.configureHttpRequest(httpRequest, "POST", "threads/runs", {"assistant_id": assistantId, "thread": thread});

            var maxRetries = 3;
            var httpResponse = apiComm.sendHttpRequest(httpRequest, maxRetries);

            // Handle HTTP response
            apiComm.handleHttpResponse(result, httpResponse);

            // Check for errors
            if (structKeyExists(result, "error")) {
                // Log the error
                apiComm.logError(result.error);
            } else {
                // Operation was successful, result.data contains the run object
                // You can use the data as needed
            }
        } catch (any e) {
            // Log unexpected errors
            apiComm.logError("An unexpected error occurred: " & e.getMessage());
            result.error = "An unexpected error occurred: " & e.getMessage();
        }

        return result;
    }

    // Function to retrieve a run step
    function RetrieveRunStep(threadId, runId, stepId) {
        var result = {};
        var httpRequest = new cfhttp();

        try {
            // Input Validation
            if (not isValid("string", threadId) or not isValid("string", runId) or not isValid("string", stepId)) {
                result.error = "Invalid input: Thread ID, Run ID, and Step ID must be valid strings.";
                apiComm.logError(result.error);
                return result;
            }

            // Set up HTTP request
            apiComm.configureHttpRequest(httpRequest, "GET", "threads/#threadId#/runs/#runId#/steps/#stepId#", {});

            var maxRetries = 3;
            var httpResponse = apiComm.sendHttpRequest(httpRequest, maxRetries);

            // Handle HTTP response
            apiComm.handleHttpResponse(result, httpResponse);

            // Check for errors
            if (structKeyExists(result, "error")) {
                // Log the error
                apiComm.logError(result.error);
            } else {
                // Operation was successful, result.data contains the run step object
                // You can use the data as needed
            }
        } catch (any e) {
            // Log unexpected errors
            apiComm.logError("An unexpected error occurred: " & e.getMessage());
            result.error = "An unexpected error occurred: " & e.getMessage();
        }

        return result;
    }

    // Function to list run steps in a run
    function ListRunSteps(threadId, runId, limit, order, after, before) {
        var result = {};
        var httpRequest = new cfhttp();

        try {
            // Input Validation
            if (not isValid("string", threadId) or not isValid("string", runId)) {
                result.error = "Invalid input: Thread ID and Run ID must be valid strings.";
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
            apiComm.configureHttpRequest(httpRequest, "GET", "threads/#threadId#/runs/#runId#/steps", queryParams);

            var maxRetries = 3;
            var httpResponse = apiComm.sendHttpRequest(httpRequest, maxRetries);

            // Handle HTTP response
            apiComm.handleHttpResponse(result, httpResponse);

            // Check for errors
            if (structKeyExists(result, "error")) {
                // Log the error
                apiComm.logError(result.error);
            } else {
                // Operation was successful, result.data contains the list of run step objects
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