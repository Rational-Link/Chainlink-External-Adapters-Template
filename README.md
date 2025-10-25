# Chainlink Node External Adapters Template
This guide provides a clear overview of how to build and customize an External Adapter for Chainlink. As a client, you'll tailor the adapter logic to meet your specific data needs. Once finalized, the adapter will be deployed and continuously executed via docker,and the Chainlink Node will implement a bridge specific to your account & job requirement.


## Repository Structure
```
my-api/
├── contract/
│   └── ClientContract.sol
├── job/
│   └── numbers-ea.toml
├── docker/
│   └── Dockerfile
├── src/
│   └── server.ts         # The External Adapter server
├── docker-compose.yml
├── package-lock.json
├── package.json
├── tsconfig.json
└── README.md
```
---

## Overview
This template demonstrates how to implement and deploy a Chainlink External Adapter. It includes:
- A sample smart contract
- A job spec configuration
- A Dockerized server for the adapter
---

## Request Structure
The External Adapter expects a JSON payload with the following format:
```json
{
  "id": "12345",
  "data": {
    "number": "42",
    "infoType": "trivia"
  }
}
```
---
## Response Structure
The adapter returns a structured JSON response:
```json
{
  "jobRunId": "12345",
  "statusCode": 200,
  "data": {
    "result": "42 is the answer to life, the universe, and everything."
  }
}
```

---
## Running the Adapter
The adapter runs inside a Docker container on the Chainlink Node operator's infrastructure. This setup ensures the job specs can trigger the adapter reliably during each execution cycle.
To start the container locally:

    ```bash
    docker compose up
    ```

---
