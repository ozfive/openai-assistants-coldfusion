# openai-assistants-coldfusion

## NOTE: THIS REPOSITORY IS STILL IN DEVELOPMENT AND WILL NOT BE PRODUCTION READY UNTIL TESTS ARE INCORPORATED

openai-assistants-coldfusion is a set of Coldfusion components providing a convenient and robust interface for interacting with the OpenAI Assistants API. Simplify the integration of OpenAI's powerful language models with your Coldfusion applications with this well-structured and easy-to-use set of components.

## Installation

## Getting Started

To get started with the OpenAI Assistants Coldfusion Components, you need to initialize the client by providing your OpenAI API key. Follow these steps:

```coldfusion
<cfscript>
apiComm = new APICommunication();
</cfscript>
```

### Example

```coldfusion
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
```

### Links

[OpenAI Assistants API](https://platform.openai.com/docs/api-reference/assistants)