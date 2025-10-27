# Chainlink Node External Adapters Template
This guide provides a clear and structured overview of how to build and customize an External Adapter. Clients are responsible for defining the adapter logic to meet their specific data requirements, while Rational Link will host and manage the server infrastructure to support these extended data needs.
You might consider using an external adapter if you need customized handling or parsing of API responses before delivering data on-chain or would like to interact with other blockchains, enabling cross-chain interoperability.
This repository demonstrates how the adapter is deployed and continuously executed using Docker or locally. It also outlines how to configure the corresponding Chainlink Node bridge and job, tailored to the client’s account and job specifications. For smart contract integration, the ClientContract.sol file provides a working example of how to consume the adapter’s output on-chain.


## Repository Structure
```
my-api/
├── contract/
│   └── ClientContract.sol  # Client request
├── docker/
│   └── Dockerfile          # Docker image
├── job/
│   └── wiki-ea.toml        # Chainlink Node Job spec
├── src/
│   └── server.ts           # External Adapter server
├── docker-compose.yml
├── package-lock.json
├── package.json
├── tsconfig.json
└── README.md
```


---

## Request Structure
The External Adapter is designed to receive a JSON payload in the following format. The example below demonstrates a request using Wikipedia as the data source:
```json
{
  "id": "12345",
  "data": {
    "titles": "Machine_learning",
    "exchars": "500"
  }
}
```
- id: A unique identifier for the job run.
- titles: The title of the Wikipedia article to query.
- exchars: The number of characters to extract from the article.

---
## Response Structure
Upon successful execution, the adapter returns a structured JSON response containing the requested data:
```json
{
  "jobRunId": "12345",
  "statusCode": 200,
  "data": {
    "result": "Machine learning (ML) is a field of study in artificial intelligence concerned with the development and study of statistical algorithms that can learn from data and generalise to unseen data, and thus perform tasks without explicit instructions. Within a subdiscipline in machine learning, advances in the field of deep learning have allowed neural networks, a class of statistical algorithms, to surpass many previous machine learning approaches in performance. ML finds application in many fields.." 
  }
}
```
- jobRunId: Echoes the original job ID for traceability.
- statusCode: Indicates the success of the request (200 = OK).
- data.result: Contains the extracted content from the specified Wikipedia article


---
## Running the Adapter
The adapter runs inside a Docker container on the Chainlink Node operator's infrastructure. This setup ensures the job specs can trigger the adapter reliably during each execution cycle.
To start the container locally:

```bash
  docker compose up
```

---
