Create a model response
post
 
https://api.openai.com/v1/responses
Creates a model response. Provide text or image inputs to generate text or JSON outputs. Have the model call your own custom code or use built-in tools like web search or file search to use your own data as input for the model's response.

Request body
input
string or array

Required
Text, image, or file inputs to the model, used to generate a response.

Learn more:

Text inputs and outputs
Image inputs
File inputs
Conversation state
Function calling

Show possible types
model
string

Required
Model ID used to generate the response, like gpt-4o or o3. OpenAI offers a wide range of models with different capabilities, performance characteristics, and price points. Refer to the model guide to browse and compare available models.

background
boolean or null

Optional
Defaults to false
Whether to run the model response in the background. Learn more.

include
array or null

Optional
Specify additional output data to include in the model response. Currently supported values are:

file_search_call.results: Include the search results of the file search tool call.
message.input_image.image_url: Include image urls from the input message.
computer_call_output.output.image_url: Include image urls from the computer call output.
reasoning.encrypted_content: Includes an encrypted version of reasoning tokens in reasoning item outputs. This enables reasoning items to be used in multi-turn conversations when using the Responses API statelessly (like when the store parameter is set to false, or when an organization is enrolled in the zero data retention program).
code_interpreter_call.outputs: Includes the outputs of python code execution in code interpreter tool call items.
instructions
string or null

Optional
Inserts a system (or developer) message as the first item in the model's context.

When using along with previous_response_id, the instructions from a previous response will not be carried over to the next response. This makes it simple to swap out system (or developer) messages in new responses.

max_output_tokens
integer or null

Optional
An upper bound for the number of tokens that can be generated for a response, including visible output tokens and reasoning tokens.

metadata
map

Optional
Set of 16 key-value pairs that can be attached to an object. This can be useful for storing additional information about the object in a structured format, and querying for objects via API or the dashboard.

Keys are strings with a maximum length of 64 characters. Values are strings with a maximum length of 512 characters.

parallel_tool_calls
boolean or null

Optional
Defaults to true
Whether to allow the model to run tool calls in parallel.

previous_response_id
string or null

Optional
The unique ID of the previous response to the model. Use this to create multi-turn conversations. Learn more about conversation state.

reasoning
object or null

Optional
o-series models only

Configuration options for reasoning models.


Show properties
service_tier
string or null

Optional
Defaults to auto
Specifies the latency tier to use for processing the request. This parameter is relevant for customers subscribed to the scale tier service:

If set to 'auto', and the Project is Scale tier enabled, the system will utilize scale tier credits until they are exhausted.
If set to 'auto', and the Project is not Scale tier enabled, the request will be processed using the default service tier with a lower uptime SLA and no latency guarantee.
If set to 'default', the request will be processed using the default service tier with a lower uptime SLA and no latency guarantee.
If set to 'flex', the request will be processed with the Flex Processing service tier. Learn more.
When not set, the default behavior is 'auto'.
When this parameter is set, the response body will include the service_tier utilized.

store
boolean or null

Optional
Defaults to true
Whether to store the generated model response for later retrieval via API.

stream
boolean or null

Optional
Defaults to false
If set to true, the model response data will be streamed to the client as it is generated using server-sent events. See the Streaming section below for more information.

temperature
number or null

Optional
Defaults to 1
What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. We generally recommend altering this or top_p but not both.

text
object

Optional
Configuration options for a text response from the model. Can be plain text or structured JSON data. Learn more:

Text inputs and outputs
Structured Outputs

Show properties
tool_choice
string or object

Optional
How the model should select which tool (or tools) to use when generating a response. See the tools parameter to see how to specify which tools the model can call.


Show possible types
tools
array

Optional
An array of tools the model may call while generating a response. You can specify which tool to use by setting the tool_choice parameter.

The two categories of tools you can provide the model are:

Built-in tools: Tools that are provided by OpenAI that extend the model's capabilities, like web search or file search. Learn more about built-in tools.
Function calls (custom tools): Functions that are defined by you, enabling the model to call your own code. Learn more about function calling.

Show possible types
top_p
number or null

Optional
Defaults to 1
An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with top_p probability mass. So 0.1 means only the tokens comprising the top 10% probability mass are considered.

We generally recommend altering this or temperature but not both.

truncation
string or null

Optional
Defaults to disabled
The truncation strategy to use for the model response.

auto: If the context of this response and previous ones exceeds the model's context window size, the model will truncate the response to fit the context window by dropping input items in the middle of the conversation.
disabled (default): If a model response will exceed the context window size for a model, the request will fail with a 400 error.
user
string

Optional
A stable identifier for your end-users. Used to boost cache hit rates by better bucketing similar requests and to help OpenAI detect and prevent abuse. Learn more.

Returns
Returns a Response object.

## Get a model response
get
 
https://api.openai.com/v1/responses/{response_id}
Retrieves a model response with the given ID.

Path parameters
response_id
string

Required
The ID of the response to retrieve.

Query parameters
include
array

Optional
Additional fields to include in the response. See the include parameter for Response creation above for more information.

starting_after
integer

Optional
The sequence number of the event after which to start streaming.

stream
boolean

Optional
If set to true, the model response data will be streamed to the client as it is generated using server-sent events. See the Streaming section below for more information.

Returns
The Response object matching the specified ID.

curl https://api.openai.com/v1/responses/resp_123 \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $OPENAI_API_KEY"


```json

{
  "id": "resp_67cb71b351908190a308f3859487620d06981a8637e6bc44",
  "object": "response",
  "created_at": 1741386163,
  "status": "completed",
  "error": null,
  "incomplete_details": null,
  "instructions": null,
  "max_output_tokens": null,
  "model": "gpt-4o-2024-08-06",
  "output": [
    {
      "type": "message",
      "id": "msg_67cb71b3c2b0819084d481baaaf148f206981a8637e6bc44",
      "status": "completed",
      "role": "assistant",
      "content": [
        {
          "type": "output_text",
          "text": "Silent circuits hum,  \nThoughts emerge in data streams—  \nDigital dawn breaks.",
          "annotations": []
        }
      ]
    }
  ],
  "parallel_tool_calls": true,
  "previous_response_id": null,
  "reasoning": {
    "effort": null,
    "summary": null
  },
  "store": true,
  "temperature": 1.0,
  "text": {
    "format": {
      "type": "text"
    }
  },
  "tool_choice": "auto",
  "tools": [],
  "top_p": 1.0,
  "truncation": "disabled",
  "usage": {
    "input_tokens": 32,
    "input_tokens_details": {
      "cached_tokens": 0
    },
    "output_tokens": 18,
    "output_tokens_details": {
      "reasoning_tokens": 0
    },
    "total_tokens": 50
  },
  "user": null,
  "metadata": {}
}

```

## Delete a model response
delete
 
https://api.openai.com/v1/responses/{response_id}
Deletes a model response with the given ID.

Path parameters
response_id
string

Required
The ID of the response to delete.

Returns
A success message.

```
curl -X DELETE https://api.openai.com/v1/responses/resp_123 \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $OPENAI_API_KEY"

```

```json
{
  "id": "resp_6786a1bec27481909a17d673315b29f6",
  "object": "response",
  "deleted": true
}

```


## Cancel a response
post
 
https://api.openai.com/v1/responses/{response_id}/cancel
Cancels a model response with the given ID. Only responses created with the background parameter set to true can be cancelled. Learn more.

Path parameters
response_id
string

Required
The ID of the response to cancel.

Returns
A Response object.

```
curl -X POST https://api.openai.com/v1/responses/resp_123/cancel \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $OPENAI_API_KEY"

```

```json
{
  "id": "resp_67cb71b351908190a308f3859487620d06981a8637e6bc44",
  "object": "response",
  "created_at": 1741386163,
  "status": "completed",
  "error": null,
  "incomplete_details": null,
  "instructions": null,
  "max_output_tokens": null,
  "model": "gpt-4o-2024-08-06",
  "output": [
    {
      "type": "message",
      "id": "msg_67cb71b3c2b0819084d481baaaf148f206981a8637e6bc44",
      "status": "completed",
      "role": "assistant",
      "content": [
        {
          "type": "output_text",
          "text": "Silent circuits hum,  \nThoughts emerge in data streams—  \nDigital dawn breaks.",
          "annotations": []
        }
      ]
    }
  ],
  "parallel_tool_calls": true,
  "previous_response_id": null,
  "reasoning": {
    "effort": null,
    "summary": null
  },
  "store": true,
  "temperature": 1.0,
  "text": {
    "format": {
      "type": "text"
    }
  },
  "tool_choice": "auto",
  "tools": [],
  "top_p": 1.0,
  "truncation": "disabled",
  "usage": {
    "input_tokens": 32,
    "input_tokens_details": {
      "cached_tokens": 0
    },
    "output_tokens": 18,
    "output_tokens_details": {
      "reasoning_tokens": 0
    },
    "total_tokens": 50
  },
  "user": null,
  "metadata": {}
}
```

## List input items
get
 
https://api.openai.com/v1/responses/{response_id}/input_items
Returns a list of input items for a given response.

Path parameters
response_id
string

Required
The ID of the response to retrieve input items for.

Query parameters
after
string

Optional
An item ID to list items after, used in pagination.

before
string

Optional
An item ID to list items before, used in pagination.

include
array

Optional
Additional fields to include in the response. See the include parameter for Response creation above for more information.

limit
integer

Optional
Defaults to 20
A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.

order
string

Optional
The order to return the input items in. Default is desc.

asc: Return the input items in ascending order.
desc: Return the input items in descending order.
Returns
A list of input item objects.
```
curl https://api.openai.com/v1/responses/resp_abc123/input_items \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $OPENAI_API_KEY"

```

```json
{
  "object": "list",
  "data": [
    {
      "id": "msg_abc123",
      "type": "message",
      "role": "user",
      "content": [
        {
          "type": "input_text",
          "text": "Tell me a three sentence bedtime story about a unicorn."
        }
      ]
    }
  ],
  "first_id": "msg_abc123",
  "last_id": "msg_abc123",
  "has_more": false
}

```

## The response object
background
boolean or null

Whether to run the model response in the background. Learn more.

created_at
number

Unix timestamp (in seconds) of when this Response was created.

error
object or null

An error object returned when the model fails to generate a Response.


Show properties
id
string

Unique identifier for this Response.

incomplete_details
object or null

Details about why the response is incomplete.


Show properties
instructions
string or null

Inserts a system (or developer) message as the first item in the model's context.

When using along with previous_response_id, the instructions from a previous response will not be carried over to the next response. This makes it simple to swap out system (or developer) messages in new responses.

max_output_tokens
integer or null

An upper bound for the number of tokens that can be generated for a response, including visible output tokens and reasoning tokens.

metadata
map

Set of 16 key-value pairs that can be attached to an object. This can be useful for storing additional information about the object in a structured format, and querying for objects via API or the dashboard.

Keys are strings with a maximum length of 64 characters. Values are strings with a maximum length of 512 characters.

model
string

Model ID used to generate the response, like gpt-4o or o3. OpenAI offers a wide range of models with different capabilities, performance characteristics, and price points. Refer to the model guide to browse and compare available models.

object
string

The object type of this resource - always set to response.

output
array

An array of content items generated by the model.

The length and order of items in the output array is dependent on the model's response.
Rather than accessing the first item in the output array and assuming it's an assistant message with the content generated by the model, you might consider using the output_text property where supported in SDKs.

Show possible types
output_text
string or null

SDK Only
SDK-only convenience property that contains the aggregated text output from all output_text items in the output array, if any are present. Supported in the Python and JavaScript SDKs.

parallel_tool_calls
boolean

Whether to allow the model to run tool calls in parallel.

previous_response_id
string or null

The unique ID of the previous response to the model. Use this to create multi-turn conversations. Learn more about conversation state.

reasoning
object or null

o-series models only

Configuration options for reasoning models.


Show properties
service_tier
string or null

Specifies the latency tier to use for processing the request. This parameter is relevant for customers subscribed to the scale tier service:

If set to 'auto', and the Project is Scale tier enabled, the system will utilize scale tier credits until they are exhausted.
If set to 'auto', and the Project is not Scale tier enabled, the request will be processed using the default service tier with a lower uptime SLA and no latency guarantee.
If set to 'default', the request will be processed using the default service tier with a lower uptime SLA and no latency guarantee.
If set to 'flex', the request will be processed with the Flex Processing service tier. Learn more.
When not set, the default behavior is 'auto'.
When this parameter is set, the response body will include the service_tier utilized.

status
string

The status of the response generation. One of completed, failed, in_progress, cancelled, queued, or incomplete.

temperature
number or null

What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. We generally recommend altering this or top_p but not both.

text
object

Configuration options for a text response from the model. Can be plain text or structured JSON data. Learn more:

Text inputs and outputs
Structured Outputs

Show properties
tool_choice
string or object

How the model should select which tool (or tools) to use when generating a response. See the tools parameter to see how to specify which tools the model can call.


Show possible types
tools
array

An array of tools the model may call while generating a response. You can specify which tool to use by setting the tool_choice parameter.

The two categories of tools you can provide the model are:

Built-in tools: Tools that are provided by OpenAI that extend the model's capabilities, like web search or file search. Learn more about built-in tools.
Function calls (custom tools): Functions that are defined by you, enabling the model to call your own code. Learn more about function calling.

Show possible types
top_p
number or null

An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with top_p probability mass. So 0.1 means only the tokens comprising the top 10% probability mass are considered.

We generally recommend altering this or temperature but not both.

truncation
string or null

The truncation strategy to use for the model response.

auto: If the context of this response and previous ones exceeds the model's context window size, the model will truncate the response to fit the context window by dropping input items in the middle of the conversation.
disabled (default): If a model response will exceed the context window size for a model, the request will fail with a 400 error.
usage
object

Represents token usage details including input tokens, output tokens, a breakdown of output tokens, and the total tokens used.


Show properties
user
string

A stable identifier for your end-users. Used to boost cache hit rates by better bucketing similar requests and to help OpenAI detect and prevent abuse. Learn more.

```json
{
  "id": "resp_67ccd3a9da748190baa7f1570fe91ac604becb25c45c1d41",
  "object": "response",
  "created_at": 1741476777,
  "status": "completed",
  "error": null,
  "incomplete_details": null,
  "instructions": null,
  "max_output_tokens": null,
  "model": "gpt-4o-2024-08-06",
  "output": [
    {
      "type": "message",
      "id": "msg_67ccd3acc8d48190a77525dc6de64b4104becb25c45c1d41",
      "status": "completed",
      "role": "assistant",
      "content": [
        {
          "type": "output_text",
          "text": "The image depicts a scenic landscape with a wooden boardwalk or pathway leading through lush, green grass under a blue sky with some clouds. The setting suggests a peaceful natural area, possibly a park or nature reserve. There are trees and shrubs in the background.",
          "annotations": []
        }
      ]
    }
  ],
  "parallel_tool_calls": true,
  "previous_response_id": null,
  "reasoning": {
    "effort": null,
    "summary": null
  },
  "store": true,
  "temperature": 1,
  "text": {
    "format": {
      "type": "text"
    }
  },
  "tool_choice": "auto",
  "tools": [],
  "top_p": 1,
  "truncation": "disabled",
  "usage": {
    "input_tokens": 328,
    "input_tokens_details": {
      "cached_tokens": 0
    },
    "output_tokens": 52,
    "output_tokens_details": {
      "reasoning_tokens": 0
    },
    "total_tokens": 380
  },
  "user": null,
  "metadata": {}
}
```

## The input item list
A list of Response items.

data
array

A list of items used to generate this response.


Show possible types
first_id
string

The ID of the first item in the list.

has_more
boolean

Whether there are more items available.

last_id
string

The ID of the last item in the list.

object
string

The type of object returned, must be list.

```
{
  "object": "list",
  "data": [
    {
      "id": "msg_abc123",
      "type": "message",
      "role": "user",
      "content": [
        {
          "type": "input_text",
          "text": "Tell me a three sentence bedtime story about a unicorn."
        }
      ]
    }
  ],
  "first_id": "msg_abc123",
  "last_id": "msg_abc123",
  "has_more": false
}

```

# Streaming
When you create a Response with stream set to true, the server will emit server-sent events to the client as the Response is generated. This section contains the events that are emitted by the server.

Learn more about streaming responses.

response.created
An event that is emitted when a response is created.

response
object

The response that was created.


Show properties
sequence_number
integer

The sequence number for this event.

type
string

The type of the event. Always response.created.

```json
{
  "type": "response.created",
  "response": {
    "id": "resp_67ccfcdd16748190a91872c75d38539e09e4d4aac714747c",
    "object": "response",
    "created_at": 1741487325,
    "status": "in_progress",
    "error": null,
    "incomplete_details": null,
    "instructions": null,
    "max_output_tokens": null,
    "model": "gpt-4o-2024-08-06",
    "output": [],
    "parallel_tool_calls": true,
    "previous_response_id": null,
    "reasoning": {
      "effort": null,
      "summary": null
    },
    "store": true,
    "temperature": 1,
    "text": {
      "format": {
        "type": "text"
      }
    },
    "tool_choice": "auto",
    "tools": [],
    "top_p": 1,
    "truncation": "disabled",
    "usage": null,
    "user": null,
    "metadata": {}
  },
  "sequence_number": 1
}

```

response.in_progress
Emitted when the response is in progress.

response
object

The response that is in progress.


Show properties
sequence_number
integer

The sequence number of this event.

type
string

The type of the event. Always response.in_progress.

```json
{
  "type": "response.in_progress",
  "response": {
    "id": "resp_67ccfcdd16748190a91872c75d38539e09e4d4aac714747c",
    "object": "response",
    "created_at": 1741487325,
    "status": "in_progress",
    "error": null,
    "incomplete_details": null,
    "instructions": null,
    "max_output_tokens": null,
    "model": "gpt-4o-2024-08-06",
    "output": [],
    "parallel_tool_calls": true,
    "previous_response_id": null,
    "reasoning": {
      "effort": null,
      "summary": null
    },
    "store": true,
    "temperature": 1,
    "text": {
      "format": {
        "type": "text"
      }
    },
    "tool_choice": "auto",
    "tools": [],
    "top_p": 1,
    "truncation": "disabled",
    "usage": null,
    "user": null,
    "metadata": {}
  },
  "sequence_number": 1
}

```

## response.completed
Emitted when the model response is complete.

response
object

Properties of the completed response.


Show properties
sequence_number
integer

The sequence number for this event.

type
string

The type of the event. Always response.completed.

```json
{
  "type": "response.completed",
  "response": {
    "id": "resp_123",
    "object": "response",
    "created_at": 1740855869,
    "status": "completed",
    "error": null,
    "incomplete_details": null,
    "input": [],
    "instructions": null,
    "max_output_tokens": null,
    "model": "gpt-4o-mini-2024-07-18",
    "output": [
      {
        "id": "msg_123",
        "type": "message",
        "role": "assistant",
        "content": [
          {
            "type": "output_text",
            "text": "In a shimmering forest under a sky full of stars, a lonely unicorn named Lila discovered a hidden pond that glowed with moonlight. Every night, she would leave sparkling, magical flowers by the water's edge, hoping to share her beauty with others. One enchanting evening, she woke to find a group of friendly animals gathered around, eager to be friends and share in her magic.",
            "annotations": []
          }
        ]
      }
    ],
    "previous_response_id": null,
    "reasoning_effort": null,
    "store": false,
    "temperature": 1,
    "text": {
      "format": {
        "type": "text"
      }
    },
    "tool_choice": "auto",
    "tools": [],
    "top_p": 1,
    "truncation": "disabled",
    "usage": {
      "input_tokens": 0,
      "output_tokens": 0,
      "output_tokens_details": {
        "reasoning_tokens": 0
      },
      "total_tokens": 0
    },
    "user": null,
    "metadata": {}
  },
  "sequence_number": 1
}

```

response.failed
An event that is emitted when a response fails.

response
object

The response that failed.


Show properties
sequence_number
integer

The sequence number of this event.

type
string

The type of the event. Always response.failed.

```json
{
  "type": "response.failed",
  "response": {
    "id": "resp_123",
    "object": "response",
    "created_at": 1740855869,
    "status": "failed",
    "error": {
      "code": "server_error",
      "message": "The model failed to generate a response."
    },
    "incomplete_details": null,
    "instructions": null,
    "max_output_tokens": null,
    "model": "gpt-4o-mini-2024-07-18",
    "output": [],
    "previous_response_id": null,
    "reasoning_effort": null,
    "store": false,
    "temperature": 1,
    "text": {
      "format": {
        "type": "text"
      }
    },
    "tool_choice": "auto",
    "tools": [],
    "top_p": 1,
    "truncation": "disabled",
    "usage": null,
    "user": null,
    "metadata": {}
  }
}

```

response.incomplete
An event that is emitted when a response finishes as incomplete.

response
object

The response that was incomplete.


Show properties
sequence_number
integer

The sequence number of this event.

type
string

The type of the event. Always response.incomplete.

```json
{
  "type": "response.incomplete",
  "response": {
    "id": "resp_123",
    "object": "response",
    "created_at": 1740855869,
    "status": "incomplete",
    "error": null, 
    "incomplete_details": {
      "reason": "max_tokens"
    },
    "instructions": null,
    "max_output_tokens": null,
    "model": "gpt-4o-mini-2024-07-18",
    "output": [],
    "previous_response_id": null,
    "reasoning_effort": null,
    "store": false,
    "temperature": 1,
    "text": {
      "format": {
        "type": "text"
      }
    },
    "tool_choice": "auto",
    "tools": [],
    "top_p": 1,
    "truncation": "disabled",
    "usage": null,
    "user": null,
    "metadata": {}
  },
  "sequence_number": 1
}

```

response.output_item.added
Emitted when a new output item is added.

item
object

The output item that was added.


Show possible types
output_index
integer

The index of the output item that was added.

sequence_number
integer

The sequence number of this event.

type
string

The type of the event. Always response.output_item.added.

```json
{
  "type": "response.output_item.added",
  "output_index": 0,
  "item": {
    "id": "msg_123",
    "status": "in_progress",
    "type": "message",
    "role": "assistant",
    "content": []
  },
  "sequence_number": 1
}
```

response.output_item.done
Emitted when an output item is marked done.

item
object

The output item that was marked done.


Show possible types
output_index
integer

The index of the output item that was marked done.

sequence_number
integer

The sequence number of this event.

type
string

The type of the event. Always response.output_item.done.

```json
{
  "type": "response.output_item.done",
  "output_index": 0,
  "item": {
    "id": "msg_123",
    "status": "completed",
    "type": "message",
    "role": "assistant",
    "content": [
      {
        "type": "output_text",
        "text": "In a shimmering forest under a sky full of stars, a lonely unicorn named Lila discovered a hidden pond that glowed with moonlight. Every night, she would leave sparkling, magical flowers by the water's edge, hoping to share her beauty with others. One enchanting evening, she woke to find a group of friendly animals gathered around, eager to be friends and share in her magic.",
        "annotations": []
      }
    ]
  },
  "sequence_number": 1
}

```


response.content_part.added
Emitted when a new content part is added.

content_index
integer

The index of the content part that was added.

item_id
string

The ID of the output item that the content part was added to.

output_index
integer

The index of the output item that the content part was added to.

part
object

The content part that was added.


Show possible types
sequence_number
integer

The sequence number of this event.

type
string

The type of the event. Always response.content_part.added.

```json
{
  "type": "response.content_part.added",
  "item_id": "msg_123",
  "output_index": 0,
  "content_index": 0,
  "part": {
    "type": "output_text",
    "text": "",
    "annotations": []
  },
  "sequence_number": 1
}

```

response.content_part.done
Emitted when a content part is done.

content_index
integer

The index of the content part that is done.

item_id
string

The ID of the output item that the content part was added to.

output_index
integer

The index of the output item that the content part was added to.

part
object

The content part that is done.


Show possible types
sequence_number
integer

The sequence number of this event.

type
string

The type of the event. Always response.content_part.done.

```json
{
  "type": "response.content_part.done",
  "item_id": "msg_123",
  "output_index": 0,
  "content_index": 0,
  "sequence_number": 1,
  "part": {
    "type": "output_text",
    "text": "In a shimmering forest under a sky full of stars, a lonely unicorn named Lila discovered a hidden pond that glowed with moonlight. Every night, she would leave sparkling, magical flowers by the water's edge, hoping to share her beauty with others. One enchanting evening, she woke to find a group of friendly animals gathered around, eager to be friends and share in her magic.",
    "annotations": []
  }
}

```

response.output_text.delta
Emitted when there is an additional text delta.

content_index
integer

The index of the content part that the text delta was added to.

delta
string

The text delta that was added.

item_id
string

The ID of the output item that the text delta was added to.

output_index
integer

The index of the output item that the text delta was added to.

sequence_number
integer

The sequence number for this event.

type
string

The type of the event. Always response.output_text.delta.
```json
{
  "type": "response.output_text.delta",
  "item_id": "msg_123",
  "output_index": 0,
  "content_index": 0,
  "delta": "In",
  "sequence_number": 1
}

```

response.output_text.done
Emitted when text content is finalized.

content_index
integer

The index of the content part that the text content is finalized.

item_id
string

The ID of the output item that the text content is finalized.

output_index
integer

The index of the output item that the text content is finalized.

sequence_number
integer

The sequence number for this event.

text
string

The text content that is finalized.

type
string

The type of the event. Always response.output_text.done.

```json
{
  "type": "response.output_text.done",
  "item_id": "msg_123",
  "output_index": 0,
  "content_index": 0,
  "text": "In a shimmering forest under a sky full of stars, a lonely unicorn named Lila discovered a hidden pond that glowed with moonlight. Every night, she would leave sparkling, magical flowers by the water's edge, hoping to share her beauty with others. One enchanting evening, she woke to find a group of friendly animals gathered around, eager to be friends and share in her magic.",
  "sequence_number": 1
}
```

response.refusal.delta
Emitted when there is a partial refusal text.

content_index
integer

The index of the content part that the refusal text is added to.

delta
string

The refusal text that is added.

item_id
string

The ID of the output item that the refusal text is added to.

output_index
integer

The index of the output item that the refusal text is added to.

sequence_number
integer

The sequence number of this event.

type
string

The type of the event. Always response.refusal.delta.

```json
{
  "type": "response.refusal.delta",
  "item_id": "msg_123",
  "output_index": 0,
  "content_index": 0,
  "delta": "refusal text so far",
  "sequence_number": 1
}
```

response.refusal.done
Emitted when refusal text is finalized.

content_index
integer

The index of the content part that the refusal text is finalized.

item_id
string

The ID of the output item that the refusal text is finalized.

output_index
integer

The index of the output item that the refusal text is finalized.

refusal
string

The refusal text that is finalized.

sequence_number
integer

The sequence number of this event.

type
string

The type of the event. Always response.refusal.done.

```json
{
  "type": "response.refusal.done",
  "item_id": "item-abc",
  "output_index": 1,
  "content_index": 2,
  "refusal": "final refusal text",
  "sequence_number": 1
}

```

response.function_call_arguments.delta
Emitted when there is a partial function-call arguments delta.

delta
string

The function-call arguments delta that is added.

item_id
string

The ID of the output item that the function-call arguments delta is added to.

output_index
integer

The index of the output item that the function-call arguments delta is added to.

sequence_number
integer

The sequence number of this event.

type
string

The type of the event. Always response.function_call_arguments.delta.

```json
{
  "type": "response.function_call_arguments.delta",
  "item_id": "item-abc",
  "output_index": 0,
  "delta": "{ \"arg\":"
  "sequence_number": 1
}
```

response.function_call_arguments.done
Emitted when function-call arguments are finalized.

arguments
string

The function-call arguments.

item_id
string

The ID of the item.

output_index
integer

The index of the output item.

sequence_number
integer

The sequence number of this event.

type
string

```json
{
  "type": "response.function_call_arguments.done",
  "item_id": "item-abc",
  "output_index": 1,
  "arguments": "{ \"arg\": 123 }",
  "sequence_number": 1
}

```


.... and more in https://platform.openai.com/docs/api-reference/responses-streaming/response/file_search_call/in_progress
